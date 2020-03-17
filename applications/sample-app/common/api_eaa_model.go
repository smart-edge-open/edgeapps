// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package common

import "encoding/json"

// NotificationDescriptor describes a type used in EAA API
type NotificationDescriptor struct {
	// Name of notification
	Name string `json:"name,omitempty"`
	// Version of notification message type
	Version string `json:"version,omitempty"`
	// Human readable description of notification
	Description string `json:"description,omitempty"`
}

// URN describes a Uniform Resource Name
type URN struct {

	// The per-namespace unique portion of the URN that when appended to
	// the namespace with a separator forms the complete URN.
	ID string `json:"id,omitempty"`

	// The non-unique portion of the URN that identifies the class excluding
	// a trailing separator.
	Namespace string `json:"namespace,omitempty"`
}

// NotificationToConsumer describes a type used in EAA API.
type NotificationToConsumer struct {
	// Name of notification
	Name string `json:"name,omitempty"`
	// Version of notification
	Version string `json:"version,omitempty"`
	// The payload can be any JSON object with a name
	// and version-specific schema.
	Payload json.RawMessage `json:"payload,omitempty"`
	// URN of the producer
	URN URN `json:"producer,omitempty"`
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

// Service is used to create producer
type Service struct {
	URN           *URN                     `json:"urn,omitempty"`
	Description   string                   `json:"description,omitempty"`
	EndpointURI   string                   `json:"endpoint_uri,omitempty"`
	Status        string                   `json:"status,omitempty"`
	Notifications []NotificationDescriptor `json:"notifications,omitempty"`
}

// ServiceList JSON struct
// This struct is used to receive list of
// registered producers
type ServiceList struct {
	Services []Service `json:"services,omitempty"`
}
