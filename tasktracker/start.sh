#!/bin/bash

export PORT=5100

cd ~/www/tasktracker
./bin/tasktracker stop || true
./bin/tasktracker start
