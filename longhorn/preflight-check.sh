#!/bin/bash

curl -L -O https://raw.githubusercontent.com/longhorn/longhorn/v1.2.2/scripts/environment_check.sh

file=./environment_check.sh
chmod +x $file
$file

rm -rf $file