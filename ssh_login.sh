#!/usr/bin/expect -f

# Inspired by: http://www.journaldev.com/1405/expect-script-example-for-ssh-and-su-login-and-running-commands

if {[llength $argv] != 3} {
    puts "usage: ssh.sh user hostname password "
    exit 1
}

set timeout 120

spawn ssh [lindex $argv 0]@[lindex $argv 1]

expect "yes/no" {
    send "yes\r"
    expect "*?assword" { send "[lindex $argv 2]\r" }
    } "*?assword" { send "[lindex $argv 2]\r" }

interact
