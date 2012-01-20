#!/bin/bash

OS=`uname -o`

PING_CMD="ping -c1 -w1 "
[[ "${OS}" == "Solaris" ]] && PING_CMD="ping "

