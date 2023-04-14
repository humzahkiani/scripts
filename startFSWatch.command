#!/usr/bin/env bash

#This script watches the Books folder for changes, and triggers the sendBooksToKindle.sh script if changes are found
cd ~/Desktop/Books

fswatch -o . | xargs -n1 -I{} /bin/bash ../../Programming/scripts/sendBooksToKindle.sh &
