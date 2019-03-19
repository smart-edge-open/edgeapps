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

package main

import (
	"context"
	"log"
	"time"

	pb "github.com/smartedgemec/appliance-ce/examples/agent/pb"
	"google.golang.org/grpc"
)

const (
	address = ":1337"
)

func main() {
	conn, err := grpc.Dial(address, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	cli := pb.NewAgentClient(conn)

	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()

	helloResp, err := cli.SayHello(ctx, &pb.HelloRequest{Name: "Dolly"})
	if err != nil {
		log.Fatalf("could not say hello: %v", err)
	}
	log.Printf("Response: %s", helloResp.GetGreeting())

	titleResp, err := cli.JobTitle(ctx, &pb.TitleRequest{})
	if err != nil {
		log.Fatalf("could not say hello: %v", err)
	}
	log.Printf("Response: %s", titleResp.GetTitle())
}
