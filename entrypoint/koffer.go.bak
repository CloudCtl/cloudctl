package main

import (
    "os"
    "io"
    "log"
    "fmt"
    "flag"
    "sync"
    "os/exec"
    "strings"
    "io/ioutil"
    "github.com/go-git/go-git"
    "github.com/go-git/go-git/plumbing"
//  "github.com/codesparta/koffer/entrypoint/src"
)

var pullsecret []byte
var secretpath = "/root/.docker/"
var secretfile = "config.json"
var secretfilepath = (secretpath + secretfile)

// Basic example of how to clone a repository using clone options.
func main() {

    svcGit := flag.String("git", "github.com", "Git Server")
    orgGit := flag.String("org", "CodeSparta", "Repo Owner/path")
    repoGit := flag.String("repo", "collector-infra", "Plugin Repo Name")
    branchGit := flag.String("branch", "master", "Git Branch")
    pathClone := flag.String("dir", "/root/koffer", "Clone Path")

    flag.Parse()

    promptQuaySecretReq()
    createSecretFile()

    // build url from vars
    gitslice := []string{ "https://", *svcGit, "/", *orgGit, "/", *repoGit }
    url := strings.Join(gitslice, "")

    // set branch
    branchslice := []string{ "refs/heads/", *branchGit }
    branch := strings.Join(branchslice, "")

    runvars := "\n" +
               "   Service: " + *svcGit + "\n" +
               "  Org/Path: " + *orgGit + "\n" +
               "      Repo: " + *repoGit + "\n" +
               "    Branch: " + *branchGit + "\n" +
               "      Path: " + *pathClone + "\n" +
               "       URL: " + url + "\n" +
               "       CMD: git clone " + url + *pathClone + "\n"
    Info(runvars)

    // Clone the given repository to the given directory
    Info("git clone %s %s", url, *pathClone)

    r, err := git.PlainClone(*pathClone, false, &git.CloneOptions{
        URL:               url,
        RecurseSubmodules: git.DefaultSubmoduleRecursionDepth,
	ReferenceName:     plumbing.ReferenceName(branch),
	SingleBranch:      true,
	Tags:              git.NoTags,
    })
    CheckIfError(err)
    // ... retrieving the branch being pointed by HEAD
    ref, err := r.Head()
    CheckIfError(err)

    // ... retrieving the commit object
    commit, err := r.CommitObject(ref.Hash())
    CheckIfError(err)

    fmt.Println(commit)

    registry := exec.Command("/usr/bin/run_registry.sh")
    err = registry.Start()
    if err != nil {
        log.Fatal(err)
    }
    err = registry.Wait()

    cmd := exec.Command("./site.yml")

    var stdout, stderr []byte
    var errStdout, errStderr error
    stdoutIn, _ := cmd.StdoutPipe()
    stderrIn, _ := cmd.StderrPipe()
    err = cmd.Start()
    if err != nil {
        log.Fatalf("cmd.Start() failed with '%s'\n", err)
    }

    var wg sync.WaitGroup
    wg.Add(1)
    go func() {
        stdout, errStdout = copyAndCapture(os.Stdout, stdoutIn)
        wg.Done()
    }()

    stderr, errStderr = copyAndCapture(os.Stderr, stderrIn)

    wg.Wait()

    err = cmd.Wait()
    if err != nil {
        log.Fatalf("cmd.Run() failed with %s\n", err)
    }
    if errStdout != nil || errStderr != nil {
        log.Fatal("failed to capture stdout \n")
    }

    errStr := string(stderr)
    //outStr, errStr := string(stdout), string(stderr)
    //fmt.Printf("\nout:\n%s\n", outStr)
    if stderr != nil {
        fmt.Printf("\nerr:\n%s\n", errStr)
    }
}


/*
  Functions
*/

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

func copyAndCapture(w io.Writer, r io.Reader) ([]byte, error) {
	var out []byte
	buf := make([]byte, 1024, 1024)
	for {
		n, err := r.Read(buf[:])
		if n > 0 {
			d := buf[:n]
			out = append(out, d...)
			_, err := w.Write(d)
			if err != nil {
				return out, err
			}
		}
		if err != nil {
			// Read returns io.EOF at the end of file, which is not an error for us
			if err == io.EOF {
				err = nil
			}
			return out, err
		}
	}
}

func promptQuaySecretReq() {
  fmt.Print(`
  Please input your Quay.io Openshift Pull Secret.
  Find your secret at this url with valid access.redhat.com login:

    https://cloud.redhat.com/openshift/install/metal/user-provisioned

  Paste Secret:  `)
  fmt.Scanln(&pullsecret)
}

func createSecretFile() {
    if _, err := os.Stat(secretpath); os.IsNotExist(err) {
        os.Mkdir(secretpath, os.FileMode(0600))
    }
    var _, err = os.Stat(secretfilepath)
    if os.IsNotExist(err) {
        file, err := os.Create(secretfilepath)
	if err != nil {
		fmt.Println(err)
		return
	}
        defer file.Close()
    }

    err = ioutil.WriteFile("/root/.docker/config.json", pullsecret, 0600)
    if err != nil {
        fmt.Println(err)
	return
    }

    fmt.Println("Created: /root/.docker/config.json")
}
