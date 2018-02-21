#!/bin/bash

export PORT=5200

cd ~/www/tasktracker
./bin/tasktracker stop || true
./bin/tasktracker start
