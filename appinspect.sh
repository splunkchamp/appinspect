#!/bin/bash

echo -n Username:
read username
echo -n Password:
read -s password
echo ""
echo -n "App Package File:"
read appnm

tok=`curl -X GET -u "$username:$password" --url 'https://api.splunk.com/2.0/rest/login/splunk' | jq -r '.data.token'`


url=`curl -X POST -H 'Authorization: bearer '$tok'' -H 'Cache-Control: no-cache' -F 'app_package=@"'$appnm'"' -F 'included_tags=cloud' --url 'https://appinspect.splunk.com/v1/app/validate'`


url=`echo $url | jq -r '.links[1].href'`

url="https://appinspect.splunk.com${url}"

echo "###################################################"
echo "######### Paste This To Get Your Report ###########"
echo "###################################################"
echo "curl -X GET -H 'Authorization: bearer '$tok'' -H 'Cache-Control: no-cache' -H 'Content-Type: text/html' --url $url -o report.html" 
