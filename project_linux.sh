<<doc
Name : Shreya Gupta
Date : 17/10/2022
Description : Command Line Test
doc
#!/bin/bash
echo -e "1.Signup\n2.Signin\n3.Exit"
read -p "Enter the option : " n

function signup ()
{
count=1
	    while [ $count -eq 1 ]
	    do
		arr=(`cat username.csv`)
		count=0
		read -p "Enter the username: " username
		for i in ${arr[*]}
		do
		    if [ $i = $username ]
		    then
			echo "Error: re-enter username"
			count=1	
		    fi
		done
	  done
	  count_1=1
	  while [ $count_1 -eq 1 ]
	  do
	      count_1=0
	      if [ ${#username} -gt 1 ]
	      then
		  echo "Enter the password: "
		  read -s pass
		  echo "Enter the confirm password: "
		  read -s pass_1
		  if [ $pass != $pass_1 ]
		  then
		      count_1=1
		      echo "password doesnt match reenter: "
		  fi
	      fi
	  done
	  echo $username>>username.csv
	  echo $pass>>password.csv 
  
}
function signin1 ()
{
    read -p "Enter the username : " user
    arr=(`cat username.csv`)
    len=`expr ${#arr[@]} - 1`
    flag=0
    

    for i in `seq 0  $len`
    do
	
	if [ $user = ${arr[i]} ]
	then
	    echo "Account is existed"
	    index=$i
	    read -sp "Enter the password : " password
	    echo
	    pass=(`cat password.csv`)
	    if [ $password = ${pass[index]} ]
	    then
		echo "Password and username are matched"		
		echo "Signin successful :)"
		echo  -e      "\e[96m                                                   WELCOME $user                                                           \e[0m"
		echo  -e      "\e[96m                                                  ALL THE BEST !!                                                          \e[0m"      
		flag=1
		
		
	    else
		echo " Password and username are not matched.......Please enter the username again"
		signin1
		
fi
	fi
    done
    if [ $flag -eq 0  ]
    then
	echo "This username does not exists"
	signin1
	 
 fi
}
function signin2 ()
{
    echo -e  "1.Take the test \n2.Exit"
    read -p "Enter your choice : " option
    case $option in
	1) line=`wc -l < questions.txt`
	    echo $line
           for i in `seq 5 5 $line`
	   do
	       head -$i questions.txt | tail -5
	       for j in `seq 10  -1  1`
	       do
		   echo -ne  "\rEnter the correct choice : $j "
		   read -t  1  choice
		   if [ -n "$choice" ]
		   then
		       break
		   else
		       choice="e"
		   

		   fi
		   
	       done
	       echo $choice >> useranswers.txt
 

	   done
	   
	    ;;
 2)  exit
     ;;
     esac
 }

function result_page ()
{
    echo -e "\e[96m                                                 RESULT PAGE                                          \e[0m   "
    
    lines=`wc -l < questions.txt`
    
    a=0
    b=1
    for i in `seq 5 5 $lines`
    do
	echo
	tc=`wc -l < answers.txt`
        head -$i questions.txt | tail -5
	for j in `seq $b 1 $tc`
	do 
	    echo
	    c=`head -$j useranswers.txt | tail -1`
	    if [ $c  !=  "e" ]
	    then
		echo "Your answer = " $c
	    fi

	    d=`head -$j answers.txt | tail -1`
	    if [ $c = $d ]
	    then
		echo -e "\e[32mCorrect answer\e[0m"
	        a=$(($a+1))
		b=$(($b+1))
		break
            elif [ $c = "e" ]
	    then
		echo -e "\e[96mTime out question \e[0m"
		echo -e "\e[32mCorrect answer = $d \e[0m"
		b=$(($b+1))
		break

	    else
		echo  -e "\e[31mWrong answer\e[0m"
		echo  -e "\e[32mCorrect answer : $d \e[0m"
		b=$(($b+1))
		break
	    fi

	done
done
echo
echo -e  "\e[35mTotal marks : $a/10\e[0m"

       
}
   
   



function password ()
{


	 
 read -sp  "Enter the password : "  password
 echo
 read -sp  "Enter the confirm password : "  c_password
 echo
 if [ $password = $c_password ]
 then
     echo  "Passwords are matched"
   echo  $password >> password.csv
   
 fi
if [ $password != $c_password ]
 then
     echo "Error : Passwords are not matching .......Please enter again"
     password
fi
}
case $n in
    
    1)  signup
	echo "Signup is done successfully :)"
	;;

   
     2)  signin1
         signin2
	 echo
      	 result_page
	 truncate -s 0 useranswers.txt
	 ;;

     3) exit	 

	;;
esac
