// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package common

import (
	"bytes"
	"crypto"
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/tls"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/json"
	"encoding/pem"
	"log"
	"net/http"

	"github.com/pkg/errors"
)

// generatePrivateKey generates a private key. The ECDSAWithSHA256 private KEY
// is need to create Certificate Request. The key uses P256 eliptic curve.
func generatePrivateKey() (*ecdsa.PrivateKey, error) {
	return ecdsa.GenerateKey(
		elliptic.P256(),
		rand.Reader,
	)
}

// prepareCertificateRequestTemplate prepares a template
// needed to sign a CSR.
// For presentation purposes CommonName of testing app is defined as
// localhost:testAppId. Normally this will defined a regular common name
// containing "hostname:appID".
func prepareCertificateRequestTemplate(
	commonName string) x509.CertificateRequest {
	template := x509.CertificateRequest{
		Subject: pkix.Name{
			CommonName:   commonName,
			Organization: []string{"TestOrg"},
		},
		SignatureAlgorithm: x509.ECDSAWithSHA256,
		EmailAddresses:     []string{"test@test.org"},
	}
	return template
}

// CreateCSR creates a CSR.
// This helper function creates PEM encoded CERTIFICATE REQUEST which will be
// sent to EAA. EAA should sign the request and return a certificate.
func createCSR(prvKey crypto.PrivateKey,
	csrTemplate x509.CertificateRequest) (string, error) {

	csrBytes, err := x509.CreateCertificateRequest(rand.Reader, &csrTemplate,
		prvKey)
	if err != nil {
		return "", errors.Wrap(err, "Couldn't generate a private key")
	}

	m := pem.EncodeToMemory(&pem.Block{Type: "CERTIFICATE REQUEST",
		Bytes: csrBytes})

	return string(m), nil
}

/* SendCSRRequest sends a CSR request to edge node to obtain a certificate.
The request is sent over unencrypted HTTP connection.
+---+                              +--------+
¦App¦                              ¦EdgeNode¦
+---+                              +--------+
  ¦     CSR request - AuthIdentity     ¦
  ¦------------------------------------>
  ¦                                    ¦
  ¦signed certificate - AuthCredentials¦
  ¦<------------------------------------
+---+                              +--------+
¦App¦                              ¦EdgeNode¦
+---+                              +--------+
*/
func sendCSRRequest(clientPrivateKey *ecdsa.PrivateKey,
	commonName string) (AuthCredentials, error) {
	var (
		identityRequest AuthIdentity
		credentialsResp AuthCredentials

		resp    *http.Response
		err     error
		reqBody []byte
	)

	if identityRequest.Csr, err = createCSR(
		clientPrivateKey,
		prepareCertificateRequestTemplate(commonName)); err != nil {
		return AuthCredentials{}, errors.Wrap(err, "Couldn't create a CSR")
	}

	if reqBody, err = json.Marshal(identityRequest); err != nil {
		return AuthCredentials{},
			errors.Wrap(err, "Couldn't Marshal request into JSON")
	}

	if resp, err = http.Post("http://"+Cfg.EdgeNodeEndpoint+"/auth", "",
		bytes.NewBuffer(reqBody)); err != nil {
		return AuthCredentials{},
			errors.Wrap(err, "Couldn't send auth request")
	}

	if err = json.NewDecoder(resp.Body).Decode(&credentialsResp); err != nil {
		return AuthCredentials{},
			errors.Wrap(err, "Couldn't decode auth response")
	}

	return credentialsResp, nil
}

// createEncryptedClient created a TLS encrypted HTTP cliet. It needs to have
// auth credensials from edge node.
func createEncryptedClient(credentialsResponse AuthCredentials,
	clientPrivateKey *ecdsa.PrivateKey) (*http.Client, error) {

	x509Encoded, err := x509.MarshalECPrivateKey(clientPrivateKey)
	if err != nil {
		return nil, errors.Wrap(err, "Couldn't marshal a private key")
	}

	pemEncoded := pem.EncodeToMemory(&pem.Block{Type: "PRIVATE KEY",
		Bytes: x509Encoded})

	cert, err := tls.X509KeyPair(
		[]byte(credentialsResponse.Certificate),
		pemEncoded)
	if err != nil {
		return nil, errors.Wrap(err, "Couldn't create a cert")
	}

	certPool := x509.NewCertPool()
	for _, c := range credentialsResponse.CaPool {
		certPool.AppendCertsFromPEM([]byte(c))
	}

	client := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{RootCAs: certPool,
				Certificates: []tls.Certificate{cert},
				ServerName:   Cfg.EaaCommonName,
			},
		}}

	tlsResp, err := client.Get("https://" + Cfg.EdgeNodeEndpoint)
	if err != nil {
		return nil, errors.Wrap(err, "Encrypted connection failure")
	}
	defer func() {
		if e := tlsResp.Body.Close(); e != nil {
			log.Println("Failed to close response body " + e.Error())
		}
	}()
	return client, nil
}

// CreateTLSClient creates TLS encrypted client.
// To be able to create TLS encrypted connection an application needs to have
// a private key. The key is generated at the beginning of CreateTLSClient(),
// but it can also be loaded from a file if it's already created. Next step
// that application needs to do is to send a CSR to /Auth API. This is done in
// sendCSRRequest function. Once the application obtain EAA certificate can
// create encrypted connection to EDGE application.
func CreateTLSClient(commonName string) (*http.Client, error) {
	var (
		credentialsResponse AuthCredentials
		clientPrivateKey    *ecdsa.PrivateKey
		err                 error
	)

	if clientPrivateKey, err = generatePrivateKey(); err != nil {
		return nil, errors.Wrap(err, "Couldn't generate private key")
	}

	if credentialsResponse, err = sendCSRRequest(clientPrivateKey,
		commonName); err != nil {
		return nil, errors.Wrap(err, "Sending CSR failed")
	}

	return createEncryptedClient(credentialsResponse, clientPrivateKey)

}
