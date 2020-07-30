package main

import (
    "os"
    "fmt"
    "flag"
    "strings"
    "github.com/go-git/go-git"
)

// Basic example of how to clone a repository using clone options.
func main() {

    svcGit := flag.String("git", "https://github.com/", "git service")
    repoGit := flag.String("repo", "RedShiftOfficial/collector-infra", "koffer plugin repo")
    branchGit := flag.String("branch", "master", "git branch")
    pathClone := flag.String("dir", "/root/deploy", "clone to directory path")


    flag.Parse()

    gitslice := []string{*svcGit, "/", *repoGit}
    url := strings.Join(gitslice, "")

    fmt.Println("     Repo: ", *repoGit)
    fmt.Println("  Service: ", *svcGit)
    fmt.Println("   Branch: ", *branchGit)
    fmt.Println("     Path: ", *pathClone)
    fmt.Println("      URL: ", url)

    // Clone the given repository to the given directory
    Info("git clone %s %s --recursive", url, *pathClone)

    r, err := git.PlainClone(*pathClone, false, &git.CloneOptions{
        URL:               url,
        RecurseSubmodules: git.DefaultSubmoduleRecursionDepth,
    })

    CheckIfError(err)
    // ... retrieving the branch being pointed by HEAD
    ref, err := r.Head()
    CheckIfError(err)
    // ... retrieving the commit object
    commit, err := r.CommitObject(ref.Hash())
    CheckIfError(err)

    fmt.Println(commit)
}

// CheckArgs should be used to ensure the right command line arguments are
// passed before executing an example.
func CheckArgs(arg ...string) {
	if len(os.Args) < len(arg)+1 {
		Warning("Usage: %s %s", os.Args[0], strings.Join(arg, " "))
		os.Exit(1)
	}
}

// CheckIfError should be used to naively panics if an error is not nil.
func CheckIfError(err error) {
	if err == nil {
		return
	}

	fmt.Printf("\x1b[31;1m%s\x1b[0m\n", fmt.Sprintf("error: %s", err))
	os.Exit(1)
}

// Info should be used to describe the example commands that are about to run.
func Info(format string, args ...interface{}) {
	fmt.Printf("\x1b[34;1m%s\x1b[0m\n", fmt.Sprintf(format, args...))
}

// Warning should be used to display a warning
func Warning(format string, args ...interface{}) {
	fmt.Printf("\x1b[36;1m%s\x1b[0m\n", fmt.Sprintf(format, args...))
}
