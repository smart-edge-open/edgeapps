// Copyright 2019 Intel Corporation and Smart-Edge.com, Inc. All rights reserved
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

package esa2

import (
	"context"
	"log"
	"net"
	"os"

	pb "github.com/smartedgemec/appliance-ce/examples/edge-sample-agent-2/pb"
	"google.golang.org/grpc"
)

const (
	address = ":42100"
)

var (
	Error *log.Logger
	Warn  *log.Logger
	Info  *log.Logger
	Trace *log.Logger
)

func init() {
	Error = log.New(os.Stdout, "ESA2 ERROR ", log.Ldate|log.Ltime|log.Lshortfile)
	Warn = log.New(os.Stdout, "ESA2 WARN ", log.Ldate|log.Ltime|log.Lshortfile)
	Info = log.New(os.Stdout, "ESA2 INFO ", log.Ldate|log.Ltime|log.Lshortfile)
	Trace = log.New(os.Stdout, "ESA2 TRACE ", log.Ldate|log.Ltime|log.Lshortfile)
}

type esa2ServiceImpl struct{}

func (service *esa2ServiceImpl) Hello(ctx context.Context, msg *pb.EhloMessage) (*pb.EhloMessage, error) {
	Info.Printf("Received Hello with msg: %v", msg.Msg)

	return &pb.EhloMessage{Msg: "ESA2 says hello"}, nil
}

// Run function is responsible for starting Edge Lifecycle Agent gRPC server
func Run(parentCtx context.Context, cfgPath string) error {
	Info.Printf("Starting with %s", cfgPath)
	ctx, cancel := context.WithCancel(parentCtx)
	defer cancel()

	lis, err := net.Listen("tcp", address)
	if err != nil {
		return err
	}

	grpcServer := grpc.NewServer()
	service := esa2ServiceImpl{}
	pb.RegisterESA2Server(grpcServer, &service)

	go func() {
		select {
		case <-ctx.Done():
			Info.Printf("Executing graceful stop")
			grpcServer.GracefulStop()
		}
	}()

	defer func() {
		Info.Printf("Stopped serving")
	}()

	Info.Printf("Serving")
	return grpcServer.Serve(lis)
}
