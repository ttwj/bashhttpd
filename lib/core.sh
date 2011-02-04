#!/usr/bin/env bash -x
source ../etc/bashhttpd.conf
function get.Index() {
   for i in $INDEX_FILES; do
      if [ "$(ls $WWW_DIR/$i)" ]; then
         cat "$(ls $WWW_DIR/$i)"
         exit 1
      fi
   done
}
function send.gzipFile() {
   file="$1"
   if [ "${file#*.}" = "sh" ]; then
      cgi.Parse "$WWW_DIR/$1"
      return 1
   else
      echo "HTTP/1.1 200 OK"
      get.ContentType "$WWW_DIR/$1"
      cat "$WWW_DIR/$1" > /tmp/data
      zip /tmp/data.zip /tmp/data
      echo -en "Content-Encoding: gzip\x0a\x0a"
      cat /tmp/data.zip
   fi
   exit 1
}
function get.ContentType() {
   FILE=$(ls $WWW_DIR | grep -w "${@}")
   FILETYPE=$(echo "$FILE" | sed -e 's/\./ \./' | awk '{print $2}')
   while read line; do
      if [ "$(echo "$line" | sed -e 's/->/ /g' | grep -w "$FILETYPE")" ]; then
         ContentType=$(echo "$line" | awk '{print $2}')
      fi
   done < ../etc/supported_filetypes
   
   if [ ! "$ContentType" ]; then
      ContentType="application/octet-stream"
   fi
   
   echo -en "Content-Type: $ContentType\x0a\x0a"
}
function send.File() {
   file="$1"
   
   
   if [ "${file#*.}" = "sh" ]; then
      cgi.Parse "$WWW_DIR/$1"
      return 1
   else
      echo "HTTP/1.1 200 OK"
      get.ContentType "$WWW_DIR/$1"
      echo ""
      cat "$WWW_DIR/$1"
   fi
   exit 1
}
function send.Header() {
   #send.Header <Header> <Data>
   data="${@}"
   echo "$1: ${data#* }"
}
function send.Response(){
   num="$1"
   case "$num" in
      200) err="OK";;
      403) err="Forbidden";;
      404) err="Not Found";;
      500) err="Internal Server Error";;
      501) err="Not Implemented";;
      *)   err="Internal Server Error"
         log err "Unknown response: $num"
         num=500
      ;;
   esac
   #send.Header "ContentType" "text/html"
   echo "HTTP/1.1 $1 $err"
   echo "$HTTP_VERSION $num $err"
   exit 1
}
function parse() {
   action=$(echo "${@}" | awk '{print $1}')
   if [ "$action" = "GET" ]; then
      HTTP_VERSION=$(echo "${@}" | awk '{print $3}' | sed -e 's/HTTP\///')
      FILE=$(echo "${@}" | awk '{print $2}' | sed -e 's/\///')
      if [ ! "$FILE" ]; then
         get.Index
         return 1
      fi
      if [ ! -e "$WWW_DIR/$FILE" ]; then
         send.Response "404"
      else
         #get.ContentType "$FILE"
         send.File "$FILE"
      fi
   fi
}
while read line; do
   parse "$line"
   
done
