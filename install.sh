#!/usr/bin/env bash

make_binary() {
  local tag
  tag="minfs-installer:$(date +'%s')"

  echo "Building maker image"
  docker build -t "${tag}" . >&1 > /dev/null

  rm -rf ./out >&1 > /dev/null
  local path
  path="$(pwd)/out-$(date +'%s')"
  mkdir -p "${path}" >&1 > /dev/null

  echo "Extracting build output"
  docker run --rm -v "${path}:/output" "${tag}" >&1 > /dev/null
  docker rmi "${tag}" >&1 > /dev/null

  echo "Preparing out directory"
  mv "${path}" out >&1 > /dev/null
}

install_binary() {
  [[ ! -f "$(pwd)/out/minfs" ]] && echo "Nothing to install, run make first." && exit 1
  [[ ! -f "$(pwd)/out/mount.minfs" ]] && echo "Nothing to install, run make first." && exit 1
  [[ ! -f "$(pwd)/out/minfs.8" ]] && echo "Nothing to install, run make first." && exit 1
  [[ ! -f "$(pwd)/out/mount.minfs.8" ]] && echo "Nothing to install, run make first." && exit 1
	sudo /usr/bin/install -m 755 out/minfs /sbin/minfs && echo "Installing minfs binary to '/sbin/minfs'"
	sudo /usr/bin/install -m 755 out/mount.minfs /sbin/mount.minfs && echo "Installing '/sbin/mount.minfs'"
	echo "Installing man pages"
	sudo /usr/bin/install -m 644 out/minfs.8 /usr/share/man/man8/minfs.8
	sudo /usr/bin/install -m 644 out/mount.minfs.8 /usr/share/man/man8/mount.minfs.8
	echo "Installation successful. To learn more, try \"minfs --help\"."
}

if [[ $# -lt 1 ]];
then
  echo "Usage: $0 make|install"
  exit 0
fi

if [[ "$1" == "make" ]];
then
  make_binary
elif [[ "$1" == "install" ]];
then
  install_binary
else
  echo "Invalid command: $1"
  exit 1
fi
