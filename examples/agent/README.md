# Example: Agent
This example demonstrates a typical agent on the Appliance. An agent is a microservice that resides on an Appliance; it exposes methods that can execute a variety of functions. By having a common framework for agents, the Appliance project can add new agents as the project needs grow with minimal integration effort.

A typical client of an agent is its counterpart microservice in the Controller. The client may communicate directly with the agent or indirectly via a proxy. In either case, this example shows how a client can use a published API definition to call methods that an agent exposes.

The following resources are part of this example:

- Top level functions and methods
- Protocol buffer (protobuf) definitions
- Service (gRPC) definitions
- gRPC server and client
- Unit tests

The following sections will go over these resources in more detail. This example assumes some basic familiarity with our dependencies. The following are some reference links if you are not familiar with them:

- Go (https://github.com/golang/go)
- Protocol Buffers (https://github.com/protocolbuffers/protobuf)
- gRPC (https://grpc.io) and using it with Go (https://github.com/grpc/grpc-go)
- Generating Go gRPC from protobuf (https://grpc.io/docs/quickstart/go.html)
- Go repository structure (https://github.com/golang-standards/project-layout)

Parts of this example agent were adapted from the above references. Additionally, some code has been generated for convenience. As this example evolves, more instructions will be provided on how to generate code.

## Top level functions and methods
At the top level of the directory is typically where the primary functions and methods are located. Depending on the complexity of the agent, this package may just be a collection of functions or may be more object-oriented and be a set of methods for an object (struct).

If the functions or methods are logically distinct, it is appropriate to separate them into different `.go` files.

## Protocol buffer (protobuf) definitions
The protobuf definition is important as it is the API contract between the agent and other services that wish to invoke the agent's functions. It is the ownership of the agent, but is externally available and should maintain backwards-compatibility as much as possible.

The protobuf definition includes not just the remote procedure calls (RPCs) but also the service definition. This allows a gRPC plugin to be used when generating a server or a client that uses the RPCs.

The protobuf definitions usually reside in a directory `pb`. This directory contains the `.proto` file at a minimum, and should also contain the generated Go code in the `.pb.go` file. The generated code used the instructions in the introduction section above.

## Service (gRPC) definitions
The gRPC service definitions lays out the API handlers. This is similar to setting up a REST API and handlers, but using a protobuf schema instead of a JSON REST schema to generate the data types and handler methods. We opted to use protobuf and gRPC for their strongly typed nature.

Perhaps most importantly, the service defined in the `server` directory implements the service definition in the protobuf definition. It uses the request and response types as well as the RPCs defined. You'll usually see a static assertion that this struct implements the interface defined in the protobuf.

## gRPC server and client
The gRPC server and client included are examples of a basic, unauthenticated server and client. They can be run in two separate processes using `go run` to try them out:

```
$ go run cmd/insecure/grpc/server/main.go
$ go run cmd/insecure/grpc/client/main.go
```

As services require more authentication, Google's gRPC library provides options for more transport authentication. You may need to pull dependencies manually until the project provides tooling to fetch them.

## Testing
The tests are responsible for testing the agent as a functional whole. In some cases, mocks are appropriate to allow tests to pass. For example, if an agent requires OS level calls to be performed, the unit tests may wish to mock out this behavior. The actual system calls are more appropriate for integration or end-to-end tests.

# Todo
There are always ways to improve this example. The following are on the todo list:
- More test coverage and examples
- CONTRIBUTING.md
- Example of using packages in the top-level `utils` directory in the repository
- RPM and/or Docker packaging of the Agent examples

