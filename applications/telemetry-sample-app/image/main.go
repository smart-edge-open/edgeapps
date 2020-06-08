// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2020 Intel Corporation

package main

import (
	"context"
	"fmt"
	"log"
	"math/rand"
	"os"
	"time"

	"contrib.go.opencensus.io/exporter/ocagent"
	"go.opencensus.io/stats"
	"go.opencensus.io/stats/view"
	"go.opencensus.io/tag"
)

func main() {
	ocAgentAddr, ok := os.LookupEnv("OTEL_AGENT_ENDPOINT")
	if !ok {
		ocAgentAddr = ocagent.DefaultAgentHost + ":" + string(ocagent.DefaultAgentPort)
	}
	fmt.Printf("OtelAgent endpoint is: %s\n", ocAgentAddr)
	oce, err := ocagent.NewExporter(
		ocagent.WithAddress(ocAgentAddr),
		ocagent.WithInsecure(),
		ocagent.WithServiceName(fmt.Sprintf("example-go-%d", os.Getpid())))
	if err != nil {
		log.Fatalf("Failed to create ocagent-exporter: %v", err)
	}
	view.RegisterExporter(oce)

	// Some stats
	keyClient, _ := tag.NewKey("client")
	keyMethod, _ := tag.NewKey("method")

	timeRunning := stats.Int64("uptime", "The time the application is running for in seconds", "s")
	randomNumber := stats.Int64("statistic", "Random number for a statistic", "")

	views := []*view.View{
		{
			Name:        "example/random_number",
			Description: "Buckets for value of generated random number",
			Measure:     randomNumber,
			Aggregation: view.Distribution(0, 10, 20, 30, 40, 50),
			TagKeys:     []tag.Key{keyClient, keyMethod},
		},
		{
			Name:        "example/application_time",
			Description: "Amount of time the application is running for",
			Measure:     timeRunning,
			Aggregation: view.LastValue(),
			TagKeys:     []tag.Key{keyClient, keyMethod},
		},
	}

	if err := view.Register(views...); err != nil {
		log.Fatalf("Failed to register views for metrics: %v", err)
	}

	ctx, _ := tag.New(context.Background(), tag.Insert(keyMethod, "repl"), tag.Insert(keyClient, "cli"))
	rng := rand.New(rand.NewSource(time.Now().UnixNano()))

	startTime := time.Now()
	var timeCounter int64 = 0
	topValue := 49

	for {
		t := time.Now()
		timeDifference := int64(t.Sub(startTime)) / 1000000000
		timeCounter = timeCounter + timeDifference
		fmt.Printf("Time running: %d\n", timeCounter)
		stats.Record(ctx, timeRunning.M(timeCounter))

		randomNo := rng.Int63n(int64(topValue))
		fmt.Printf("Random number generated: %d\n", randomNo)
		stats.Record(ctx, randomNumber.M(randomNo))
		time.Sleep(time.Duration(1000) * time.Millisecond)

	}
}
