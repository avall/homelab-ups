#!/bin/bash

if [[ $(crontab -l | egrep -v "^(#|$)" | grep -q "$PWD/update.sh"; echo $?) == 1 ]]
then
    crontab -l | { cat; echo "0 4 * * * sh $PWD/update.sh"; } | crontab -
fi


