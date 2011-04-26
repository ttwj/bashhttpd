#!/bin/bash
function control.Find() {
   #control.Find <directory>
   #Finds the control files in that directory
   control=$(find "$WWW_DIR" -name *.control | grep -w "$1" | sed -n 1p)
   echo "$control"
}
function control.basicAuth() {
   #control.basicAuth <file> <user> <pass>
   send.Response '401'
   echo 'WWW-Authenticate: Basic realm="Secure Area"'
   echo 'Content-Type: text/html'
   echo '
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
 "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">
<HTML>
  <HEAD>
    <TITLE>Error</TITLE>
    <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=ISO-8859-1">
  </HEAD>
  <BODY><H1>401 Unauthorized.</H1></BODY>
   </HTML>'

}
