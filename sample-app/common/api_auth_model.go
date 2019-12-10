// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package common

// AuthCredentials defines a response for a request to obtain authentication
// credentials. These credentials may be used to further communicate with
// endpoint(s) that are protected by a form of authentication.
//
// Any strings that are annotated as "PEM-encoded" implies that encoding format
// is used, with any newlines indicated with `\n` characters. Most languages
// provide encoders that correctly marshal this out. For more information,
// see the RFC here: https://tools.ietf.org/html/rfc7468
type AuthCredentials struct {
	ID          string   `json:"id,omitempty"`
	Certificate string   `json:"certificate,omitempty"`
	CaChain     []string `json:"ca_chain,omitempty"`
	CaPool      []string `json:"ca_pool,omitempty"`
}

// AuthIdentity defines a request to obtain authentication credentials. These
// credentials would be used to further communicate with endpoint(s) that are
// protected by a form of authentication.
//
// Any strings that are annotated as "PEM-encoded" implies that encoding format
// is used, with any newlines indicated with `\n` characters. Most languages
// provide encoders that correctly marshal this out. For more information,
// see the RFC here: https://tools.ietf.org/html/rfc7468
type AuthIdentity struct {
	Csr string `json:"csr,omitempty"`
}
