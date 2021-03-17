# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2019-2020 Intel Corporation

export GO111MODULE = on

.PHONY: build build-docker consumer consumer-docker producer producer-docker clean lint help
TMP_DIR:=$(shell mktemp -d)
BUILD_DIR ?=build

VER:=1.0

build: producer consumer 

build-docker: consumer-docker producer-docker

consumer:
	export GOSUMDB=off
	mkdir -p "${BUILD_DIR}"
	CGO_ENABLED=0 GARCH=amd64 GOOS=linux go build -o "${BUILD_DIR}/consumer" ./simpleEaaConsumer
	unset GOSUMDB

consumer-docker: consumer
	cp simpleEaaConsumer/Dockerfile "${TMP_DIR}/Dockerfile_consumer"
	cp build/consumer "${TMP_DIR}"
	cp docker-compose.yml "${TMP_DIR}"
	cd "${TMP_DIR}" && VER=${VER} docker-compose -f docker-compose.yml build consumer

producer:
	go version
	export GOSUMDB=off
	mkdir -p "${BUILD_DIR}"
	CGO_ENABLED=0 GARCH=amd64 GOOS=linux go build -o "${BUILD_DIR}/producer" ./simpleEaaProducer
	unset GOSUMDB

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
