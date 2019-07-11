#! /bin/sh
sudo apt update
sudo apt install clang llvm libelf-dev
sudo apt install linux-tools-$(uname -r)
sudo apt install linux-headers-$(uname -r)
sudo apt install bcc bpfcc-tools