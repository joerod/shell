 #! /bin/bash

#creates directories and moves files to correct folders
my_dir=`dirname $0`
mkdir $HOME/Documents/gam
mkdir $HOME/Documents/gam/scripts
unzip $my_dir/gam-2.55-python-src.zip -d $HOME/Documents/gam
cp $my_dir/gapps.sh $HOME/Documents/gam/scripts
cp $my_dir/oauth.txt $HOME/Documents/gam/
rm $my_dir/oauth.txt

#Creates alias to make it easier to run scripts
bash="$HOME/.profile"
if grep -q "alias gam='python $HOME/Documents/gam/gam.py'" $bash; then
   exit
 else
 echo \ "alias gam='python $HOME/Documents/gam/gam.py'" >> $bash
fi

if grep -q "alias gapps='sh $HOME/Documents/gam/scripts/gapps.sh'" $bash; then
   exit
else
 echo \ "alias gapps='sh $HOME/Documents/gam/scripts/gapps.sh'" >> $bash
fi

exit
