#! /bin/bash

gam="$HOME/bin/gam/gam" #set this to the location of your GAM binaries
start_date=`date +%Y-%m-%d` # sets date for vacation message in proper formate   
end_date=`date -v+90d +%Y-%m-%d` #adds 90 days to todays date for vacation message
newuser(){
   echo "    gApps Admin"
  read -p "Enter email address to admin: " email
    if [[ -z $email ]];
      then echo "Please enter an email address to proceed";
      read -p "Enter email address to admin: " email
    fi  
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
 echo "4. Check Group Membership"
 echo "5. Remove From One Group"
 echo "6. Remove From All Groups"
 echo "7. Remove $email from GAL"
 echo "8. Reset Password"
 echo "9. Suspend User"
 echo "10. Offboarding"
 echo "11. Show all calendars"
 echo "12. Mirror $email's Groups to another user"
 echo "13. Forward $email's Emails to another user"
 echo "14. Admin Another User"
 echo "15. Exit"
 echo "Please enter option [1 - 15]"
    read opt
    case $opt in
     1) echo "************ Set Vacation Message / Remove Forward *************";
        read -p "Please enter vacation message: " vaca_message
        $gam user $email forward off
        $gam user $email vacation on subject 'Out of the office' message "$vaca_message" startdate $start_date enddate $end_date 
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
    
     4) echo "************ Check Group Membership ************";
        purge_groups=$($gam info user $email| grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:'|grep -B 100 'Licenses:'| grep -v 'Licenses:')|sort )
        for i in $purge_groups
            do
               echo $i
            done;
        echo "Groups have been checked [enter] key to continue. . .";
        read enterKey;;
     
     5) echo "************ Remove From One Group ************";
        read -p "Enter Group name to be removed " group_name
        $gam update group $group_name remove owner $email
        $gam update group $group_name remove member $email
        echo "Group has been removed press [enter] key to continue. . .";
        read enterKey;;
   
     
     6) echo "************ Remove From All Groups ************";
        purge_groups=$($gam info user $email| grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:'|grep -B 100 'Licenses:'| grep -v 'Licenses:')
           for i in $purge_groups
            do
               echo removing from $i
               $gam update group $i remove member $email
            done;
        echo "All groups removed press [enter] key to continue. . .";
        read enterKey;;
   
        
     7) echo "************ Remove $email from GAL ************";
        $gam user $email profile unshared
        echo "User is now hidden from the GAL Press [enter] key to continue. . .";
        read enterKey;;
        
     8) echo "************ Reset Password ************";
        randpassword=$(env LC_CTYPE=C tr -dc "a-zA-Z0-9-_\$\?" < /dev/urandom | head -c 8) #creates random 8 charecter password
        $gam update user $email password $randpassword
        echo "Password has been reset to $randpassword [enter] key to continue. . .";
        read enterKey;;  

     9) echo "************ Suspend  User ************";
        $gam update user $email suspended on
        echo "User is now suspended press [enter] key to continue. . .";
        read enterKey;;

     10) echo "************ Offboarding ************";
        randpassword=$(env LC_CTYPE=C tr -dc "a-zA-Z0-9-_\$\?" < /dev/urandom | head -c 8)
        read -p "Please enter vacation message: " vaca_message
        $gam user $email forward off
        $gam user $email vacation on subject 'Out of the office' message "$vaca_message" startdate $start_date enddate $end_date
        $gam user $email signature '';
        $gam user $email profile unshared
        $gam update user $email password $randpassword
        purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:'|grep -B 100 'Licenses:'| grep -v 'Licenses:')
           for i in $purge_groups
            do
               echo removing $i            
               $gam update group $i remove member $email
            done;
        echo "All tasks preformed press password has been set to $randpassword [enter] key to continue. . .";
        read enterKey;;

     11) echo "************ Show all calendars ************";
        $gam user $email show calendars
         echo "All tasks preformed press [enter] key to continue. . .";
        read enterKey;;

     12) echo "************ Mirror $email groups to another user ************";
        read -p  "Enter email address to be mirrored: " mirrored;
        echo $email groups will be mirrored to $mirrored press 1 if this is OK or 2 to exit;
        read answer
        if [ "$answer" -eq "1" ]
         then
              purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:'|grep -B 100 'Licenses:'| grep -v 'Licenses:')
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
         
     13) echo "************ Forward $email's Emails to another user ************";
         read -p  "Enter email address where mail will be forwarded: " forward;
         gam user $email forward on $forward keep
         echo "Emails are bing forwarded press [enter] key to continue. . .";
        read enterKey;;
        
     14) echo "************ Admin Another User ************";
        newuser;       
        echo "Press [enter] key to continue. . .";
        read enterKey;;
    
     15) echo "Bye $USER";
        exit 1;; 
        
     *) echo "$opt is an invaild option. Please select option between 1-15 only"
       echo "Press [enter] key to continue. . .";
        read enterKey;;
esac
done
