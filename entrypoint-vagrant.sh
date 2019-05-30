#!/bin/bash

which docker-compose > /dev/null 2>&1
if [ $? -eq 0 ]; then
    docker-compose down
    docker-compose up
fi
