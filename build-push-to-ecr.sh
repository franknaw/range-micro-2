#!/usr/bin/env bash

. ./acct.sh
echo "$acct"

ver="0.0.1"
image="range-micro-2"

podman build -t $image:$ver .

podman tag $image:$ver $acct.dkr.ecr.us-east-1.amazonaws.com/$image:$ver
podman tag $image:$ver $acct.dkr.ecr.us-east-1.amazonaws.com/$image:latest

aws ecr get-login-password --region us-east-1 | podman login --username AWS --password-stdin $acct.dkr.ecr.us-east-1.amazonaws.com

podman push $acct.dkr.ecr.us-east-1.amazonaws.com/$image:$ver
podman push $acct.dkr.ecr.us-east-1.amazonaws.com/$image:latest

