#! /bin/bash

gam="python gam/gam.py" #set this to the location of your GAM binaries
DATE=`date +%Y-%m-%d`
randpassword=$(date | md5sum | head -c 8) #creates a random 8 charecter password
n
newuser(){
   echo "     gApps Admin"
   read -p "Enter email address to admin: " email
   }

clear
newuser
while :
do
 clear
 echo "Currently Managing $email"
 echo "   M A I N - M E N U"
 echo "1. Set Vacation Message /Remove Forward"
 echo "2. Delete Signature"
 echo "3. Check Vacation Message"
 echo "4. Remove From All Groups"
 echo "5. Check Group Membership"
 echo "6. Remove $email from GAL"
 echo "7. Reset Password"
 echo "8. Suspend User"
 echo "9. Perform All Tasks"
 echo "10. Show all calendars"
 echo "11. Mirror $email's Groups to another user"
 echo "12. Admin Another User"
 echo "13. Exit"
 echo "Please enter option [1 - 13]"
    read opt
    case $opt in
     1) echo "************ Set Vacation Message / Remove Forward *************";
        read -p "Please enter vacation message: " vaca_message
        read -p "Enter vacation message end date YYYY-MM-DD: " end_date
        $gam user $email forward off
        $gam user $email vacation on subject 'Out of the office' message "$vaca_message" startdate $DATE enddate $end_date
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
               echo removing $i
               $gam update group $i remove member $email
            done;
        echo "All groups removed press [enter] key to continue. . .";
        read enterKey;;
     5) echo "************ Check Group Membership ************";
        purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1)
        echo $purge_groups;
        echo "Groups have been checked [enter] key to continue. . .";
        read enterKey;;
        
     6) echo "************ Remove $email from GAL ************";
        $gam user $email profile unshared
        echo "User is now hidden from the GAL Press [enter] key to continue. . .";
        read enterKey;;
        
     7) echo "************ Reset Password ************";
        $gam update user $email password $randpassword
        echo "Password has been reset to $randpassword [enter] key to continue. . .";
        read enterKey;;  

     8) echo "************ Suspend  User ************";
        $gam update user $email suspended on
        echo "User is now suspended press [enter] key to continue. . .";
        read enterKey;;

     9) echo "************ Perform All Tasks ************";
        read -p "Please enter vacation message: " vaca_message
        read -p "Enter vacation message end date YYYY-MM-DD: " end_date
        $gam user $email forward off
        $gam user $email vacation on subject 'Out of the office' message "$vaca_message" startdate $DATE enddate $end_date
        $gam user $email signature '';
        $gam user $email profile unshared
        $gam update user $email password $randpassword
        purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:')
           for i in $purge_groups
            do
               echo removing $i            
               $gam update group $i remove member $email
            done;
        echo "All tasks preformed press [enter] key to continue. . .";
        read enterKey;;

     10) echo "************ Show all calendars ************";
        $gam user $email show calendars
         echo "All tasks preformed press [enter] key to continue. . .";
        read enterKey;;

     11) echo "************ Mirror $email groups to another user ************";
        read -p  "Enter email address to be mirrored: " mirrored;
        echo $email groups will be mirrored to $mirrored press 1 if this is OK or 2 to exit;
        read answer
        if [ "$answer" -eq "1" ]
         then
              purge_groups=$($gam info user $email |grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:')
                 for i in $purge_groups
                  do
                     echo adding $mirror to $i group  
                     $gam update group $i add member $mirrored
                  done;
          echo "All groups have been mirrored press [enter] key to continue. . .";
          read enterKey;
        else
             clear
             newuser
         fi;;

     12) echo "************ Admin Another User ************";
        newuser;       
        echo "Press [enter] key to continue. . .";
        read enterKey;;
    
    13) echo "Bye $USER";
        exit 1;; 
     *) echo "$opt is an invaild option. Please select option between 1-13 only"
       echo "Press [enter] key to continue. . .";
        read enterKey;;
esac
done
