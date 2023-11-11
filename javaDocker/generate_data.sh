#!/bin/sh

cd /opt/app
java -jar DIGen.jar -sf $1 -o gendata/
