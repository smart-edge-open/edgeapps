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

package esa

import (
	"context"
	"log"
	"net"
	"os"

	esa2 "github.com/smartedgemec/appliance-ce/examples/edge-sample-agent-2/pb"
	pb "github.com/smartedgemec/appliance-ce/examples/edge-sample-agent/pb"
	"google.golang.org/grpc"
)

const (
	address     = "localhost:42109"
	esa2Address = "localhost:42100"
)

var (
	Error *log.Logger
	Warn  *log.Logger
	Info  *log.Logger
	Trace *log.Logger
)

func init() {
	Error = log.New(os.Stdout, "ESA ERROR ", log.Ldate|log.Ltime|log.Lshortfile)
	Warn = log.New(os.Stdout, "ESA WARN ", log.Ldate|log.Ltime|log.Lshortfile)
	Info = log.New(os.Stdout, "ESA INFO ", log.Ldate|log.Ltime|log.Lshortfile)
	Trace = log.New(os.Stdout, "ESA TRACE ", log.Ldate|log.Ltime|log.Lshortfile)
}

type esaServiceImpl struct{}

func (service *esaServiceImpl) Hello(ctx context.Context, msg *pb.HelloMessage) (*pb.HelloMessage, error) {
	Info.Printf("Received Hello with msg: %v. Forwarding it to ESA2", msg.Msg)

	conn, err := grpc.Dial(esa2Address, grpc.WithInsecure())
	if err != nil {
		return &pb.HelloMessage{Msg: "ESA says hello but ESA2 does not: dial failed " + err.Error()}, nil
	}
	defer conn.Close()
	cli := esa2.NewESA2Client(conn)

	// TODO: Context probably should be one that was passed to Run func
	resp, err := cli.Hello(context.TODO(), &esa2.EhloMessage{Msg: msg.Msg})
	if err != nil {
		return &pb.HelloMessage{Msg: "ESA says hello but ESA2 does not: Hello() failed: " + err.Error()}, nil
	}

	return &pb.HelloMessage{Msg: "ESA says hello and " + resp.Msg}, nil
}

// Run function is responsible for starting Edge Sample Agent gRPC server
func Run(parentCtx context.Context, cfgPath string) error {
	Info.Printf("Starting with %s", cfgPath)
	ctx, cancel := context.WithCancel(parentCtx)
	defer cancel()

	lis, err := net.Listen("tcp", address)
	if err != nil {
		return err
	}

	grpcServer := grpc.NewServer()
	service := esaServiceImpl{}
	pb.RegisterESAServer(grpcServer, &service)

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
