################################################################################
# Copyright 2019 Intel Corporation and Smart-Edge.com, Inc. All rights reserved
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

export GO111MODULE = on

.PHONY: build consumer producer clean lint help
TMP_DIR:=$(shell mktemp -d)
BUILD_DIR ?=build

VER:=1.0

build: consumer producer

consumer:
	mkdir -p "${BUILD_DIR}"
	GOOS=linux go build -o "${BUILD_DIR}/consumer" ./simpleEaaConsumer

producer:
	mkdir -p "${BUILD_DIR}"
	GOOS=linux go build -o "${BUILD_DIR}/producer" ./simpleEaaProducer

clean:
	rm -rf "${BUILD_DIR}"

lint:
	golangci-lint run

help:
	@echo "Please use \`make <target>\` where <target> is one of"
	@echo "  build       to build the consumer and producer test application"
	@echo "  producer    to build the producer test application"
	@echo "  consumer    to build the consumer test application"
	@echo "  clean       to clean up build artifacts"
	@echo "  lint        to run linters and static analysis on the code"
