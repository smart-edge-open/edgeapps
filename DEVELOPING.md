<!-- omit in toc -->
# Development Guide

- [C coding style](#c-coding-style)
- [Go coding style](#go-coding-style)
  - [Step-by-step guide](#step-by-step-guide)
  - [Cloning Go projects](#cloning-go-projects)
  - [Managing dependencies](#managing-dependencies)
  - [Viewing docs](#viewing-docs)
  - [Writing docs](#writing-docs)
  - [Building static binaries](#building-static-binaries)
  - [Error handling](#error-handling)
  - [Cancellation](#cancellation)
- [RESTful APIs](#restful-apis)
- [Protobuf & gRPC](#protobuf--grpc)
  - [File structure](#file-structure)
  - [Generation](#generation)
  - [gRPC guidelines](#grpc-guidelines)
  - [Error handling](#error-handling-1)
  - [Additional installation methods](#additional-installation-methods)
- [License headers](#license-headers)

## C coding style
Contributions in the C programming language should align with the [Linux Kernel coding guidelines](https://www.kernel.org/doc/html/latest/process/coding-style.html). Source files can be converted to a patch file that can be checked for formatting and syntax issues using the Linux Kernel [`checkpatches.sh`](https://github.com/torvalds/linux/blob/master/scripts/checkpatch.pl) script. Or, the `checkpatch.pl` script can validate individual source files when executed as follows:

```shell
./checkpatch.pl --no-tree -f <sourcefile>
```

## Go coding style
Go is very specific about using whitespaces in code. All code should be formatted using the [Gofmt tool](https://golang.org/cmd/gofmt/) prior to committing. Many editors have plugins to automatically format your code correctly upon each save (e.g. "Go Plus" for the Atom editor).

In addition to using the Gofmt tool, all style mistakes indicated by the [Golint tool](https://github.com/golang/lint) must be addressed before committing. The Golint tool is also a standard tool in Golang suites for IDE's like VSCode and Atom.

New to Go? Follow this guide to get started!

### Step-by-step guide
1. Install Go 1.12.13 or higher: https://golang.org/dl/
2. Setup your Go workspace:  https://golang.org/doc/code.html
    Recommend setting the following environment variables in your `.bashrc` or `.zshrc`:

    ```shell
    export GOPATH=$HOME/go
    export PATH=$GOPATH/bin:$PATH
    ```

    If you use [fish](https://fishshell.com/), you can put this in your `.config/fish/config.fish`:

    ```shell
    set -x GOPATH "$HOME/go"
    set PATH "$GOPATH/bin" $PATH
    ```

3. Install your editor of choice
    a. VSCode with Go extension
    b. VIM with [vim-go](https://github.com/fatih/vim-go)

> It is **not** recommended to use `go get` to get your dependencies, to clone your source repositories or to manage your dependencies.  The `go get` client is very simple and will populate your `$GOPATH/src` path with clones of the dependencies at the latest branch from the master branch (or the default branch if the source is from a VCS other than git). It also places all dependencies in `$GOPATH/src` which is shared with all projects and can affect the version of dependencies used of projects in an unexpected manner.

### Cloning Go projects
It is highly recommended to clone your Go projects with `git` (or your preferred VCS tool) rather than using `go get`. An example of this is (using SSH for cloning):
```shell
mkdir -p $GOPATH/src/gitserver/group
git clone ssh://git@gitserver/proj.git \
    $GOPATH/src/gitserver/group/proj
cd $GOPATH/src/gitserver/group/proj.git
```

Doing this allows you to choose to use HTTPS or SSH for cloning your repository, depending on the clone URL you use.
It is **not** recommended to use `go get` to clone your repository.

### Managing dependencies
It is highly recommended to use [Go Modules](https://github.com/golang/go/wiki/Modules) to manage dependencies.
To initialize a new module:

```shell
go mod init github.com/you/hello
go: creating new go.mod: module github.com/you/hello
```

This will produce a `go.mod` file. To add dependencies, you can use a command such as `go get foo@v1.2.3`, or edit the `go.mod` file.
When a contributor pulls the repository and starts to build the project, `go build` will automatically fetch dependencies defined in go.mod.
Alternatively, you can run the following to download dependencies:

```shell
go mod download
```

In your project repository, commit both the `go.mod` and the `go.sum` files.
See the [Go Modules](https://github.com/golang/go/wiki/Modules) documentation for more information.

### Viewing docs

You can view documentation for all code in your workspace by running the Godoc web server:
```shell
godoc -http=:6060
```

The preceding command will allow you to view the documentation at [http://localhost:6060](http://localhost:6060/)
You can also view documentation using a Go plugin for your IDE/editor.

### Writing docs
At a minimum, all documentation errors indicated by the [Golint tool](https://github.com/golang/lint) must be addressed before committing code. This will include documentation for any public package variables, functions, types, and methods.

Additionally, it is strongly encouraged to write package overviews in a special Go file named `doc.go`. Any multi-line comment preceding the package declaration will be included in the package overview when viewed in `Godoc`.

[Simple examples of usage can be demonstrated using testable examples.](https://blog.golang.org/examples)

### Building static binaries
One of the unique features of Go is that it is designed to always build a relatively static binary. We emphasize relatively because Go still has external dependencies such as C-libraries for networking. In order to produce truly static binaries, we need to take a few extra steps when building:

1. Ensure that the standard C library you are using to statically compile is not copylefted (e.g. GNU Stdlib is not okay, but MIT Musl is okay).
2. Use the `netgo` option to include the Golang native DNS resolver
3. Pass arguments to compilation to statically bake values into the binary, such as Version or CI Build number.

Here is an example of a complete compile command:
```shell
GOOS=linux go build -a --ldflags '-extldflags "-static"' -tags netgo -installsuffix netgo ./cmd/agentsvc
```

### Error handling

Some guidelines for using [errors](http://github.com/pkg/errors):

* When a new error occurs, use `errors.New` or `errors.Errorf`.
* When you get an error from an external library, use `errors.Wrap` and add a descriptive message.
* When you get an error from an internal library, just return it with `errors.WithStack`
* When actually handling the error (e.g. logging it or determining the next action) use `%v` to print it, or `%+v` to print a stack trace.
* Logging at the **INFO** level should never print a stack trace. Stack traces are appropriate at the **DEBUG** level.

For more background information and tips, see these articles:
* [Don’t just check errors, handle them gracefully](https://dave.cheney.net/2016/04/27/dont-just-check-errors-handle-them-gracefully)
* [Stack traces and the errors package](https://dave.cheney.net/2016/06/12/stack-traces-and-the-errors-package)

### Cancellation

Whenever a function call blocks for extended periods of time (most commonly because of network IO, waiting for an async event, or polling activity) a context should be the first parameter so that the operation may be cancelled by the parent context. Here is an example:

```go
func WaitForResponse(ctx context.Context) error {
    select {
        case <-ctx.Done():
            return ctx.Err():
 
        case response := <-responseChannel:
            fmt.Printf("Response received: %s\n", response)
            return nil
    }
}
```

Note that the context parameter is typically named `ctx` as a common Go convention.

Also note that when a context is cancelled, the corresponding cancellation error, `ctx.Err()`, should be returned so that the caller knows the function returned early due to cancellation.

## RESTful APIs
REST APIs must be compliant with [OpenAPI](https://swagger.io/resources/open-api/) specification. [Swagger Editor](https://editor.swagger.io/) is a nice tool for editing and validating the RESTful API definitions. The generated schema files must be in JSON format; the YAML format is optional. For OpenAPI Specification Version 2.0 (OAS 2.0), the schema file(s) should be named as:

```shell
./<schema-name>.swagger.json
./<schema-name>.swagger.yaml
```

For OpenAPI Specification Version 3.0 (OAS 3.0), the schema file(s) should be be named as:

```shell
./<schema-name>.openapi.json
./<schema-name>.openapi.yaml
```

## Protobuf & gRPC

### File structure
Each service that hosts a gRPC service should also host the protobuf definition and source code stubs in the `pb` directory at the top level of the repo. This convention allows other services to easily find the definition files in case a new client must be written. The `grpc` directory contains a server abstraction at the top level and within subdirectories contains implementations of that server based on the PB server definition and the server abstraction.

```
myApp
├── cmd
│   └── myApp
│       └── myApp.go
├── myApp_suite_test.go
├── myApp_test.go
├── pb
│   └── myApp.proto
|   └── myApp.pb.go
├── grpc
│   └── grpc_generated.go
│   └── myApp
│       └── myApp.go
└── pkg
    ├── myApp.go
    └── myApp_test.go
```

### Generation
Assuming the above directory structure, you can generate the client and server code by running:

```shell
pwd
/Users/csmith/go/src/myApp
protoc -I pb/ pb/myApp.proto --go_out=plugins=grpc:pb
```

### gRPC guidelines
When writing service definitions, it is sometimes useful to use the `Empty` type as a parameter/result in endpoints from which you do not need further information. This is okay to do and will not create issues later when the `Empty` type is replaced with a different type.

### Error handling
Use `grpc.Errorf`.

### Additional installation methods
Make sure that your `$GOPATH` and `$GOBIN` are set and are in your `$PATH` (see [this documentation](https://golang.org/cmd/go/) for more info on usage of these variables in Go). For example, here's my `~/.bash_profile` on my Mac. You may have to call `source ~/.bash_profile` if you want this to take effect in your current terminal session:

```shell
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH:$GOBIN
```
Next, perform the installation instructions at this link: https://github.com/grpc/grpc-go. Specifically, run the following:

```shell
go get -u google.golang.org/grpc
go get -u github.com/golang/protobuf/{proto,protoc-gen-go}
```

Then, go to this link and download the compiled binaries for your OS (for example, there's one for macOS): https://github.com/protocolbuffers/protobuf/releases

After you download the binaries, copy them inside the folder `bin` called `protoc` in your folder `$GOBIN`. Copy the contents of the folder `include` (which should just be a folder called `google`) to your `$GOPATH/src` folder.

Now, you have all the necessary tools. Be sure that your project has all of its dependencies by running `dep ensure` (or whatever its dependency tool is). Some projects allow you to run `go generate`, which will pick up on commented generate commands. Others will require you to call `protoc` directly. Here's an example of what it would look like if the code supported `go generate`:

```
//go:generate protoc -I $GOPATH/src/../proj/pb -I $GOPATH/src -I $GOPATH/src/../proj --go_out=plugins=grpc:../../../pb/progname $GOPATH/src/.../proj/pb/progname.proto
```

## License headers

All files must be headed at the first line with SPDX short identifier: [Apache-2.0](https://spdx.org/licenses/Apache-2.0.html). In the case of `#!scripts`, SPDX identifier can be placed in the second line of the file. Here are some examples:

For Golang files:
```golang
// SPDX-License-Identifier: Apache-2.0
// Copyright (c) [YEAR] [CORPORATION]
```

For C/C++ files:
```cpp
/* SPDX-License-Identifier: Apache-2.0
 * Copyright(c) [YEAR] [CORPORATION]
 */
```

For Makefile, Dockerfile, YAML, JSON or Ansible files:
```makefile
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) [YEAR] [CORPORATION]
```

For Shell scripts:
```shell
#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) [YEAR] [CORPORATION]
```

For Python scripts:
```python
#!/usr/bin/env python
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) [YEAR] [CORPORATION]
```
