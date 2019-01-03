#!/bin/bash
#Script to check a redirect.txt file with curl
#Created by Maximilian Haefner 
#elements@pulsars.eu

read -e -p "Please give me the Basis URL: " -i "https://www." basisURL
echo
read -e -p "Path to the redirect file :" -i "/etc/httpd/conf/rewritemaps" file
echo "Working  on it.."
counter1=0
counter2=0


while read p
        do
                sourceA="$(echo $p | awk -F ' '  '{print $1}')"
                targetB="$(echo $p | awk -F ' '  '{print $2}' | sed -e "s/^\([^[:space:]]\{1,\}\)\([[:space:]]\{1,\}\)/\L\1\2/" | dos2unix | tr '[:upper:]' '[:lower:]')"

                curl -Is $basisURL$sourceA > /tmp/tmp

                detectedType="$(cat /tmp/tmp | head -n1)"
                detectedLink="$(cat /tmp/tmp | grep "Location" | awk -F ' ' '{print $2}' | sed -e "s/^\([^[:space:]]\{1,\}\)\([[:space:]]\{1,\}\)/\L\1\2/" | dos2unix | tr '[:upper:]' '[:lower:]')"
                detectedLink="$(python -c "import urllib, sys; print urllib.unquote(sys.argv[1])" $detectedLink)"


                if [ "$detectedLink" == "$targetB" ]
                then
                        echo "Match" >> /dev/null
                        let counter1++
                fi



                if [ "$detectedLink" != "$targetB" ]
                then
                        if [ "$detectedLink" == "$basisURL$targetB" ]
                        then
                                echo "Match" >> /dev/null
                                let counter1++
                        else
                                echo "Target does not match the link from the List!"
                                echo "Detected Redirect: "$detectedLink
                                echo "Source Link from List: "$sourceA
                                echo "Target Link from List: "$targetB
                                echo "Type: "$detectedType
                                echo
                                let counter2++
                        fi
                fi




        done < $file

        echo "Programm finished!"
        echo "$counter1 Ok"
        echo "$counter2 Errors"
exit 1

                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
