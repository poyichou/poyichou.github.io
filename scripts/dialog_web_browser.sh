#!/bin/sh -x

exec 2> ~/.mybrowser/error
quit=1
cancel=0
page="google.com"
skipcurrent=0
pagestate=0
inputmsg="type command or url"
ipage=0
index=1
total=1
url="https://google.com"
#test
if [ $( ls ~ | grep '^Downloads$' ) != "Downloads" ]; then
	mkdir ~/Downloads
fi
if [ $( ls -a ~ | grep '^\.mybrowser$' ) != ".mybrowser" ]; then
	mkdir ~/.mybrowser
fi
#insert help page
echo "URL ==> go to the source code" >~/.mybrowser/help
echo "/S ==> show me the source code" >>~/.mybrowser/help
echo "/L ==> select a link to go" >>~/.mybrowser/help
echo "/D ==> select a link to download" >>~/.mybrowser/help
echo "/H ==> help page" >>~/.mybrowser/help
echo '!${cmd} ==> execute the shell cmd' >>~/.mybrowser/help
#insert userterms
echo "Are you agree the userterms??" >~/.mybrowser/userterm
#insert error code
echo "Invalid Input" >~/.mybrowser/error
echo "Try /H for help messages." >>~/.mybrowser/error
#insert first page
echo "https://google.com" >~/.mybrowser/iPages
dialog --title "terms" --yesno "$(cat ~/.mybrowser/userterm)" 1000 100
yn=$?

#disagree
if [ $yn != 0  ]; then
	quit="2"
	dialog --title "Apology" --msgbox "Sorry, You cant't use Browser, if you don't agree the user terms" 1000 100
fi

while [ "$quit" != "2" ]
do
	cancel=0
	if [ $skipcurrent != "1" ] && [ $pagestate = 0 ]; then
		#homepage
		dialog --title "Browser" --msgbox "$(w3m -dump $page)" 1000 100
	elif [ $skipcurrent != "1" ] && [ $pagestate = 1 ]; then
		#curl
		dialog --title "browser" --msgbox "$(curl -s -L $page)" 1000 100
		pagestate=0
	elif [ $skipcurrent != "1" ] && [ $pagestate = 2 ]; then
		#manual
		dialog --title "help" --msgbox "`cat "$page"`" 1000 100
	elif [ $skipcurrent != "1" ] && [ $pagestate = 3 ]; then
		dialog --title "browser" --msgbox "$page" 1000 100
	fi
	dialog --title "Browser" --inputbox "$page" 8 100 2>~/.mybrowser/command
	#quit
	if [ $? = 1 ]; then
		quit="2"
		cancel="1"
	#cancel
	elif [ $? = 255 ]; then
		cancel="1"
	fi
	skipcurrent=0
	
	com=`cat ~/.mybrowser/command`
	if [ "$quit" != "2" ] && [ "$cancel" != "1" ] && [ "$com" = "/S" ]; then
			pagestate=1
                        page=$url
#			dialog --title "browser" --msgbox "$(curl -s -L $page)" 1000 100
	elif [ "$quit" != "2" ] && [ "$cancel" != "1" ] && [ "$com" = "last" ]; then
		if [ $index -ge 2 ]; then
			index=$(expr $index - 1)
			page=$(awk 'NR == '"$index"' {print $0}' ~/.mybrowser/iPages)
			pagestate=0
		else
			dialog --msgbox "no last page QQ" 200 100
		fi
	elif [ "$quit" != "2" ] && [ "$cancel" != "1" ] && [ "$com" = "next" ]; then
		if [ $index -lt $total ]; then
			index=$(expr $index + 1)
			page=$(awk 'NR == '"$index"' {print $0}' ~/.mybrowser/iPages)
			pagestate=0
		else
			dialog --msgbox "no next page QQ" 200 100
		fi
	
	elif [ "$quit" != "2" ] && [ "$cancel" != "1" ] && [ "$com" = "/L" ]; then
		curl -s -L $url | grep '<a.*href' | sed -e 's/.*<a.*href="//g' -e 's/".*>.*//g' -e 's/[[:space:]]//g' -e 's~^\/~'"$url"'\/~g' | awk '/tps:\/\// {print NR, $0} /tp:\/\// {print NR, $0} /[^: ]/ {print NR, var "\/"  $0}' var="$url"| sed 's/.*http.*http.*//g' | grep '[1-9]'  >~/.mybrowser/Link
		if [ "$cancel" != "1" ]; then
			dialog --title "browser" --menu "Links" 1000 100 100 `cat ~/.mybrowser/Link` 2>~/.mybrowser/Choice
		
			#cancel
			if [ $? != 0 ]; then
				cancel="1"
			fi
			
			if [ "$cancel" != "1" ]; then
				catchoice=`cat ~/.mybrowser/Choice`
				churl=$(grep ^$(cat ~/.mybrowser/Choice | sed 's/\$//g')\  ~/.mybrowser/Link | sed 's/^'"$catchoice"'\ //g')
				pagestate=0
				page=$churl
				url=$churl
				if [ $index -eq 1 ]; then
					sed -n '1p' ~/.mybrowser/iPages >~/.mybrowser/tmptmp
				else
					sed -n '1,'"$index"'p' ~/.mybrowser/iPages >~/.mybrowser/tmptmp
				fi
				cat ~/.mybrowser/tmptmp >~/.mybrowser/iPages
				echo $churl >>~/.mybrowser/iPages
				index=$(expr $index + 1)
				total=$index
			fi
		fi
	elif [ "$quit" != "2" ] && [ "$cancel" != "1" ] && [ "$com" = "/H"  ]; then
		dialog --title "Help" --msgbox "`cat ~/.mybrowser/help`" 200 100
	elif [ "$quit" != "2" ] && [ "$cancel" != "1" ] && [ "$com" = "/D" ]; then
		if [ "$cancel" != "1" ]; then
			curl -s -L $url | grep '<a.*href' | sed -e 's/.*<a.*href="//g' -e 's/".*>.*//g' -e 's/[[:space:]]//g' -e 's~^\/~'"$url"'\/~g' | awk '/tps:\/\// {print NR, $0} /tp:\/\// {print NR, $0} /[^: ]/ {print NR, var "\/"  $0}' var="$url" | sed 's/.*http.*http.*//g' | grep '[1-9]' >~/.mybrowser/Link
		fi
		while [ "$cancel" != "1" ]
		do
			dialog --title "browser" --menu "Download:" 1000 100 100 `cat ~/.mybrowser/Link` 2>~/.mybrowser/Choice
			
			#cancel
			if [ $? != 0 ]; then
				cancel="1"
			fi
			if [ "$cancel" != "1" ]; then
				catchoice=`cat ~/.mybrowser/Choice`
				churl=$(grep ^$(cat ~/.mybrowser/Choice | sed 's/\$//g')\  ~/.mybrowser/Link | sed 's/^'"$catchoice"'\ //g')
				fetch -o ~/Downloads "$churl" 2>~/.mybrowser/Result
#				pagestate=3
#				page=`cat ~/.mybrowser/Result`
				cancel="1"
#				dialog --title "browser" --msgbox "$(cat ~/.mybrowser/Result)" 1000 100
			fi
		done
#	elif [ "$quit" != "2" ] && [ "$com" = "Q" ]; then
#		quit="2"
#		dialog --title "browser" --msgbox "Stop!!" 200 100
	elif [ "$quit" != "2" ] && [ "$cancel" != "1" ] && [ "$com" = "/B" ]; then
		j="1"
		while [ "$cancel" != "1" ] && [ $j != "2" ]
		do
			#delete blank row
			cat ~/.mybrowser/Bookmarks | grep '[a-zA-z0-9]' >~/.mybrowser/tmp
			cat ~/.mybrowser/tmp >~/.mybrowser/Bookmarks
			dialog --title "browser" --menu "Bookmarks:" 1000 100 100 1 "Add Bookmarks" 2 "Delete Bookmarks" $(cat ~/.mybrowser/Bookmarks | awk '{print NR+2, $0}') 2>~/.mybrowser/Mark
			
			#cancel
			if [ $? != 0 ]; then
				cancel="1"
			fi
			if [ "$cancel" != "1" ]; then
				catmark=`cat ~/.mybrowser/Mark`
			fi
#			mark==$(grep ^$(cat ~/.mybrowser/Mark | sed 's/\$//g')\  ~/.mybrowser/Bookmarks | sed 's/^'"$catmark"'\ //g')
			if [ "$cancel" != "1" ] && [ $catmark = "1" ]; then
				dialog --title "Add Bookmarks:" --inputbox "type url:" 8 100 2>~/.mybrowser/AddBook
				
				#cancel
				if [ $? != 0 ]; then
					cancel="1"
				fi

				if [ "$cancel" != "1" ]; then
					if [ $(sed 's/nasa\.cs\.nctu\.edu\.tw/iamurl/g' ~/.mybrowser/AddBook) != "iamurl" ]; then
						while [ "$cancel" != "1" ] && [ $(sed -e 's/^http:\/\/[A-Za-z0-9][A-Za-z0-9]*\.[A-Za-z0-9].*/iamurl/g' ~/.mybrowser/AddBook) != "iamurl" ] && [ $(sed -e 's/^https:\/\/[A-Za-z0-9][A-Za-z0-9]*\.[A-Za-z0-9].*/iamurl/g' ~/.mybrowser/AddBook) != "iamurl" ]
						do
							dialog --title "Add Bookmarks:" --inputbox "that doesn't url, type url again:" 8 100 2>~/.mybrowser/AddBook
							#cancel
							if [ $? != 0 ]; then
								cancel="1"
							fi
						done
						if [ "$cancel" != "1" ]; then
							cat ~/.mybrowser/AddBook >>~/.mybrowser/Bookmarks
							echo $'\n'>>~/.mybrowser/Bookmarks
							dialog --title "Add Bookmarks:" --msgbox "Added!!" 8 100
							
							#cancel
							if [ $? != 0 ]; then
								cancel="1"
							fi
						fi
					fi
				fi
			elif [ "$cancel" != "1" ] && [ $catmark = "2" ]; then
				dialog --title "Delete Bookmarks:" --menu "choose one" 1000 100 100 $(cat ~/.mybrowser/Bookmarks | awk '{print NR, $0}') 2>~/.mybrowser/DeleteBook
				
				#cancel
				if [ $? != 0 ]; then
					cancel="1"
				fi

				if [ "$cancel" != "1" ]; then
					catdeletebook=`cat ~/.mybrowser/DeleteBook`
					chbook=$(awk ' NR == '"$catdeletebook"'  {print $0} ' ~/.mybrowser/Bookmarks )
					cat ~/.mybrowser/Bookmarks | grep -v $chbook >~/.mybrowser/tmp 
					cat ~/.mybrowser/tmp >~/.mybrowser/Bookmarks
					dialog --title "Delete Bookmarks:" --msgbox "Deleted!!" 8 100
					
					#cancel
					if [ $? != 0 ]; then
						cancel="1"
					fi
				fi
			elif [ "$cancel" != "1" ] && [ $catmark -ge 3 ]; then
				chbook=$(awk ' NR == '"$catmark -2"'  {print $0} ' ~/.mybrowser/Bookmarks )
#				dialog --title "browser" --msgbox "$(w3m -dump "$chbook")" 200 100
				#cancel
				if [ $? != 0 ]; then
					cancel="1"
				fi
				if [ "$cancel" != "1" ]; then
					pagestate=0
					page=$chbook
					url=$chbook
					j="2"
					if [ $index -eq 1 ]; then
						sed -n '1p' ~/.mybrowser/iPages >~/.mybrowser/tmptmp
					else
						sed -n '1,'"$index"'p' ~/.mybrowser/iPages >~/.mybrowser/tmptmp
					fi
					cat ~/.mybrowser/tmptmp >~/.mybrowser/iPages
					echo $chbook >>~/.mybrowser/iPages
					index=$(expr $index + 1)
					total=$index
				fi
			else
				j="2"
			fi
		done

	#type url
	elif [ "$quit" != "2" ] && [ $(echo $com | sed -e 's/^http:\/\/[A-Za-z0-9][A-Za-z0-9]*\.[A-Za-z0-9].*/iamurl/g') = "iamurl" ] || [ $(echo $com | sed -e 's/^https:\/\/[A-Za-z0-9][A-Za-z0-9]*\.[A-Za-z0-9].*/iamurl/g') = "iamurl" ] || [ $com = "nasa.cs.nctu.edu.tw/sap" ]; then
		url=$com
		page=$com
		inputmsg=$com
		if [ $index -eq 1 ]; then
			sed -n '1p' ~/.mybrowser/iPages >~/.mybrowser/tmptmp
		else
			sed '1,'"$index"'p' ~/.mybrowser/iPages >~/.mybrowser/tmptmp
		fi
		cat ~/.mybrowser/tmptmp >~/.mybrowser/iPages
		echo $com >>~/.mybrowser/iPages
		index=$(expr $index + 1)
		total=$index
	#type wrong command
	elif [ "$quit" != "2" ] && [ "$cancel" != "1" && $( echo $com | sed -e 's/^\/.*/wrongcammand/g' ) != "wrongcammand" ]; then
		dialog --title "Invalid input" --msgbox "`echo "Invalid Input";echo "Try /H for help messages."`" 1000 100
		#cancel
		if [ $? != 0 ]; then
			cancel="1"
		fi
		skipcurrent="1"
	elif [ "$quit" != "2" ] && [ $( echo $com | sed -e 's/^!.*/0/g' ) = 0 ]; then
		shellcom=$( echo $com | sed -e 's/^!//g' )
		$shellcom >shellcomResult
		dialog --title "shell command" --msgbox "`cat shellcomResult`" 200 100
	elif [ "$quit" != "2" ]; then
		skipcurrent="1"
		dialog --title "Invalid input" --msgbox "`echo "Invalid Input";echo "Try /H for help messages."`" 1000 100
	fi
done 
