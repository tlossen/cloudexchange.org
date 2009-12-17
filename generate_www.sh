#!/usr/bin/env bash
wget -r http://localhost:4567
mkdir -p www
cp -r localhost\:4567/* www
rm -rf localhost\:4567
cp www/charts/eu-west-1.linux.m1.small.html www/index.html