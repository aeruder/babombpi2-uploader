#!/usr/bin/env bash

cd "`dirname "$0"`"
exec bundler exec fileshare.rb
