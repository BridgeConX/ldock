#!/bin/bash

# PHP & Nginx
docker build -t phpnginx ./phpnginx

# MySQL
docker build -t mysql ./mysql

# Redis
docker build -t redis ./redis

# Data
docker build -t data ./data