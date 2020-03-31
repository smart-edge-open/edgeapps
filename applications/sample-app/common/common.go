// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Intel Corporation

package common

// SampleNotification defines a notification which is sent from a producer to
// a consumer
var SampleNotification = []NotificationDescriptor{
	{
		Name:        Cfg.Notification,
		Version:     Cfg.VerNotif,
		Description: "Event #1 description",
	},
}
