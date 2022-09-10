package main

import (
	"os"

	"github.com/sfluor/protohackers/challenges/smoketest"
)

func main() {
	addr := os.Args[1]
	panic(smoketest.Start(addr))
}
