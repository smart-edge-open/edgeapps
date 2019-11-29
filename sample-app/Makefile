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

.PHONY: build build-docker consumer consumer-docker producer producer-docker clean lint help
TMP_DIR:=$(shell mktemp -d)
BUILD_DIR ?=build

VER:=1.0

build: consumer producer

build-docker: consumer-docker producer-docker

consumer:
	mkdir -p "${BUILD_DIR}"
	GOOS=linux go build -o "${BUILD_DIR}/consumer" ./simpleEaaConsumer

consumer-docker: consumer
	cp simpleEaaConsumer/Dockerfile "${TMP_DIR}/Dockerfile_consumer"
	cp build/consumer "${TMP_DIR}"
	cp docker-compose.yml "${TMP_DIR}"
	cd "${TMP_DIR}" && VER=${VER} docker-compose -f docker-compose.yml build consumer

producer:
	mkdir -p "${BUILD_DIR}"
	GOOS=linux go build -o "${BUILD_DIR}/producer" ./simpleEaaProducer

producer-docker: producer
	cp simpleEaaProducer/Dockerfile "${TMP_DIR}/Dockerfile_producer"
	cp build/producer "${TMP_DIR}"
	cp docker-compose.yml "${TMP_DIR}"
	cd "${TMP_DIR}" && VER=${VER} docker-compose -f docker-compose.yml build producer

clean:
	rm -rf "${BUILD_DIR}"

lint:
	golangci-lint run

help:
	@echo "Please use \`make <target>\` where <target> is one of"
	@echo "  build            to build the consumer and producer test application"
	@echo "  build-docker     to build the consumer and producer test application docker images"
	@echo "  producer         to build the producer test application"
	@echo "  producer-docker  to build the producer test application docker image"
	@echo "  consumer         to build the consumer test application"
	@echo "  consumer-docker  to build the consumer test application docker image"
	@echo "  clean            to clean up build artifacts"
	@echo "  lint             to run linters and static analysis on the code"
