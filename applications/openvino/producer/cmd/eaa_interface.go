// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package main

import "encoding/json"

// NotificationDescriptor describes a type used in EAA API
type NotificationDescriptor struct {
	// Name of notification
	Name string `json:"name,omitempty"`
	// Version of notification
	Version string `json:"version,omitempty"`
	// Human readable description of notification
	Description string `json:"description,omitempty"`
}

// NotificationFromProducer describes a type used in EAA API
type NotificationFromProducer struct {
	// Name of notification
	Name string `json:"name,omitempty"`
	// Version of notification
	Version string `json:"version,omitempty"`
	// The payload can be any JSON object with a name
	// and version-specific schema.
	Payload json.RawMessage `json:"payload,omitempty"`
}

// Service JSON struct
type Service struct {
	URN           *URN                     `json:"urn,omitempty"`
	Description   string                   `json:"description,omitempty"`
	EndpointURI   string                   `json:"endpoint_uri,omitempty"`
	Status        string                   `json:"status,omitempty"`
	Notifications []NotificationDescriptor `json:"notifications,omitempty"`
}

// URN describes a type used in EAA API
type URN struct {

	// The per-namespace unique portion of the URN that when appended to
	// the namespace with a separator forms the complete URN.
	ID string `json:"id,omitempty"`

	// The non-unique portion of the URN that identifies the class excluding
	// a trailing separator.
	Namespace string `json:"namespace,omitempty"`
}

// AuthCredentials defines a response for a request to obtain authentication
// credentials. These credentials may be used to further communicate with
// endpoint(s) that are protected by a form of authentication.
//
// Any strings that are annotated as "PEM-encoded" implies that encoding format
// is used, with any newlines indicated with `\n` characters. Most languages
// provide encoders that correctly marshal this out. For more information,
// see the RFC here: https://tools.ietf.org/html/rfc7468
//type AuthCredentials struct {
//	ID          string   `json:"id,omitempty"`
//	Certificate string   `json:"certificate,omitempty"`
//	CaChain     []string `json:"ca_chain,omitempty"`
//	CaPool      []string `json:"ca_pool,omitempty"`
//}

// AuthIdentity defines a request to obtain authentication credentials. These
// credentials would be used to further communicate with endpoint(s) that are
// protected by a form of authentication.
//
// Any strings that are annotated as "PEM-encoded" implies that encoding format
// is used, with any newlines indicated with `\n` characters. Most languages
// provide encoders that correctly marshal this out. For more information,
// see the RFC here: https://tools.ietf.org/html/rfc7468
//type AuthIdentity struct {
///	Csr string `json:"csr,omitempty"`
//}
