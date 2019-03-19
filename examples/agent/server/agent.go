// Copyright 2019 Smart-Edge.com, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package server

import (
	"context"
	"github.com/smartedgemec/appliance-ce/examples/agent"
	pb "github.com/smartedgemec/appliance-ce/examples/agent/pb"
)

// Statically assert that Agent implements the pb.AgentServer interface
var _ pb.AgentServer = &Agent{}

// Agent implements the pb.AgentServer interface
type Agent struct{}

// SayHello takes in a HelloRequest and returns a HelloResponse
func (a *Agent) SayHello(ctx context.Context, in *pb.HelloRequest) (
	*pb.HelloResponse, error,
) {
	return &pb.HelloResponse{
		Greeting: agent.Hello(in.GetName()),
	}, nil
}

// JobTitle takes in a TitleRequest and returns a TitleResponse
func (a *Agent) JobTitle(ctx context.Context, in *pb.TitleRequest) (
	*pb.TitleResponse, error,
) {
	return &pb.TitleResponse{
		Title: agent.Title("Junior Example"),
	}, nil
}
