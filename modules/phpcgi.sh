#!/bin/bash
# opens a phpcgi parser, explosions? i hope not.

# THIS IS FOR CHECKING FOR SCRIPT IMPORT, BECAUSE THIS CAN CAUSE PAIN.
PHP_CGIPATH=$(which php-cgi)
if test "$PHP_CGIPATH" == "" ; then
	echo "php-cgi is required by the bashhttpd cgi module. install the php5-cgi package from your local package manager"
	break
	exit 1
fi

function phpcgi.Parse () {
	#phpcgi.Parse <file>
}
