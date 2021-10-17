# Installer for `minfs`

This repo has a simple installation script which spins
up a Docker container to keep the build dependencies
of the binary from mucking up the host system.

## Making the Binary

To make the binary, you will need to run the `make` command:

```bash
./install.sh make
```

Once this is done, a directory called `out` will be created which
contains the binaries as well as man DB documentations from
the original make script.

The installer will also delete the docker image it created, as well 
as any other dependencies, so, you can rest assured that no
lingering effects will remain.

## Installing the Binary

The `install` target is taken directly from the Makefile of the original
`minfs` repo. To install, simply run:

```bash
./install.sh install
```
