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

package insecure_test

import (
	"context"
	"os/exec"
	"time"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"

	"github.com/onsi/gomega/gexec"
	pb "github.com/smartedgemec/appliance-ce/examples/agent/pb"
	"google.golang.org/grpc"
)

var _ = Describe("Acceptance: Agent", func() {
	var (
		agent *gexec.Session
	)

	Describe("As a gRPC service", func() {
		BeforeEach(func() {
			exe, err := gexec.Build(
				"github.com/smartedgemec/appliance-ce/" +
					"examples/agent/cmd/insecure/grpc/server",
			)
			Expect(err).ToNot(HaveOccurred())
			cmd := exec.Command(exe)
			agent, err = gexec.Start(cmd, GinkgoWriter, GinkgoWriter)
			Expect(err).ToNot(HaveOccurred())

			time.Sleep(100 * time.Millisecond)
		})

		AfterEach(func() {
			if agent != nil {
				agent.Kill()
			}
		})

		It("Should say hello on gRPC request", func() {
			conn, err := grpc.Dial(":1337", grpc.WithInsecure())
			Expect(err).NotTo(HaveOccurred())
			defer conn.Close()

			cli := pb.NewAgentClient(conn)

			ctx, cancel := context.WithTimeout(context.Background(), time.Second)
			defer cancel()

			resp, err := cli.SayHello(ctx, &pb.HelloRequest{Name: "Dolly"})
			Expect(err).NotTo(HaveOccurred())
			Expect(resp.GetGreeting()).To(Equal("Hello, Dolly!"))
		})
	})
})
