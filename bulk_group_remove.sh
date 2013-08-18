#!/bin/bash
#this will bulk remove users from all groups in Google apps, I uses GAM to execute the script.

gam="python $HOME/Documents/gam/gam.py" #set this to the location of your GAM binaries
while read -r line
do
 purge_groups=$($gam info user $line | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |sort )
for i in $purge_groups
            do
               echo removing $line from $i
               $gam update group $i remove member $line
            done
done < users #this is the file to read lines from
