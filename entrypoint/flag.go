package main

import (
    "flag"
    "fmt"
)

var myFlags arrayFlags
type arrayFlags []string

func main() {
    flag.Var(&myFlags, "plugin", "plugin repo name")
    flag.Parse()
    for _, element := range myFlags {
        kofferLoop(element)
    }
}

func kofferLoop(element string) {
    fmt.Println(element)
}

func (i *arrayFlags) String() string {
    return "values"
}

func (i *arrayFlags) Set(value string) error {
    *i = append(*i, value)
    return nil
}
