#!/bin/bash

#Author: Tino -  Based on https://github.com/duffycop/nagios_plugins/blob/master/plugins/check_service
#No Modifications done till now, am justing it directly - will work on adding system checking as per my other check_linux_service.sh script to this

#VARIABLES NAGIOS
OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3

PROGNAME=`basename $0 .sh`
VERSION="Version 1.1"

print_version() {
    echo "$VERSION"
}

print_help() {
    print_version $PROGNAME $VERSION
    echo ""
    echo "$PROGNAME is a Nagios plugin to check a specific service using systemctl."
    echo ""
    echo "$PROGNAME -s <service_name>"
    exit $UNKNOWN
}

if test -z "$1"
then
        print_help
        exit $CRITICAL
fi

while test -n "$1"; do
    case "$1" in
        --help|-h)
            print_help
            exit $UNKNOWN
            ;;
        --version|-v)
            print_version $PROGNAME $VERSION
            exit $UNKNOWN
            ;;
        --service|-s)
            SERVICE=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            print_help
            exit $UNKNOWN
            ;;
        esac
    shift
done

if systemctl is-active $SERVICE >/dev/null 2>&1
then
    echo "OK: Service $SERVICE is running!"
    exit $OK
else
    echo "CRITICAL: Service $SERVICE is not running!"
    exit $CRITICAL
fi