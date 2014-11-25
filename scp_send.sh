#!/usr/bin/expect -f

if {[llength $argv] != 3} {
    puts "usage: ./scp_send.sh file user@host:/path password"
    exit 1
}

set timeout 120

spawn scp [lindex $argv 0] [lindex $argv 1]

expect "yes/no" {
    send "yes\r"
    expect "*?assword" { send "[lindex $argv 2]\r" }
    } "*?assword" { send "[lindex $argv 2]\r" }

interact
