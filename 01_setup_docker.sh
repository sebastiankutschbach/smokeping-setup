#!/bin/bash
set -e
set -o pipefail

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo usermod -aG docker dlp0mts
