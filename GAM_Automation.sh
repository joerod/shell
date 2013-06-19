#! /bin/bash

gam="python /gam/gam.py" #set this to the location of your GAM binaries
clear
newuser(){
   echo "    gApps Admin"
   read -p "Enter email address to admin: " email
}
clear
newuser
while :
do
 clear
 echo "   M A I N - M E N U"
 echo "1. Set Vacation Message /Remove Forward"
 echo "2. Delete Signature"
 echo "3. Check Vacation Message"
 echo "4. Remove From All Groups"
 echo "5. Check Group Membership"
 echo "6. Perform All Tasks"
 echo "7. Admin Another User"
 echo "8. Exit"
 echo "Please enter option [1 - 8]"
    read opt
    case $opt in
     1) echo "************ Set Vacation Message / Remove Forward *************";
        read -p "Please enter vacation message: " vaca_message
        $gam user $email forward off
        $gam user $email vacation on subject 'Out of the office' message "$vaca_message";
        echo "Press [enter] key to continue. . .";
        read enterKey;;
     2) echo "************ Delete Signature ************";
        $gam user $email signature ' ';
        echo "Press [enter] key to continue. . .";
        read enterKey;;
     3) echo "************ Current Vacation Message ************";
        $gam  user $email show vacation;
        echo "Press [enter] key to continue. . .";
        read enterKey;;
     4) echo "************ Remove From All Groups ************";
        purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:')
           for i in $purge_groups
            do
               echo removing $i |$gam update group $i remove member $email
            done;
        echo "All groups removed press [enter] key to continue. . .";
        read enterKey;;
     5) echo "************ Check Group Membership ************";
        purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1)
        echo $purge_groups;
        echo "Groups have been checked [enter] key to continue. . .";
        read enterKey;;
     6) echo "************ Perform All Tasks ************";   
        read -p "Please enter vacation message: " vaca_message
        $gam user $email forward off
        $gam user $email vacation on subject 'Out of the office' message "$vaca_message";
        $gam user $email signature ' ';
        purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:')
           for i in $purge_groups
            do
               echo removing $i |$gam update group $i remove member $email
            done;
        echo "All tasks preformed press [enter] key to continue. . .";
        read enterKey;;
     7) echo "************ Admin Another User ************";
        newuser;       
        echo "Press [enter] key to continue. . .";
        read enterKey;;
     8) echo "Bye $USER";
        exit 1;; 
     *) echo "$opt is an invaild option. Please select option between 1-8 only"
       echo "Press [enter] key to continue. . .";
        read enterKey;;
esac
done


