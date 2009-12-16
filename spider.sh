#!/usr/bin/env bash
wget -r -i files.txt
mv localhost\:8000/ www
cp www/charts/eu-west-1.linux.m1.small.html www/index.html