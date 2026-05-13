#!/bin/bash
# Installation qui évite les problèmes des versions les plus récentes

docker run --rm -v "$PWD:/out" ubuntu:20.04 bash -c '
  apt-get update -qq >/dev/null && apt-get install -qq -y git build-essential libssl-dev >/dev/null
  git clone -q https://github.com/iagox86/hash_extender /tmp/he
  cd /tmp/he && make >/dev/null && cp hash_extender /out/
'
