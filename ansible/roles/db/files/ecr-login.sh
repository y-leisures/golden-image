#!/usr/bin/env bash

set -euo pipefail
set -x
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 949140100595.dkr.ecr.ap-northeast-1.amazonaws.com
