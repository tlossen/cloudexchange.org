#!/usr/bin/env bash
wget -r -i files.txt
cp -r localhost\:8000/* www
rm -rf localhost\:8000
cp www/charts/eu-west-1.linux.m1.small.html www/index.html