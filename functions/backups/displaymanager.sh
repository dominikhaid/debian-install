#!/usr/bin/expect

spawn  dpkg-reconfigure lightdm -freadline
expect "2. lightdm"
send "2\r"

# done
expect eof
