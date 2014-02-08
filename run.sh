#!/bin/bash
./roa.pl

if [ -e restart.me ]; then 
rm restart.me
./run.sh
fi

