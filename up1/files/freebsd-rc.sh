#! /bin/sh

# up1 {{ service_name }}
# Maintainer: @tim
# Authors: @tim

# PROVIDE: {{ service_name }}
# REQUIRE: LOGIN
# KEYWORD: shutdown

. /etc/rc.subr

name="{{ service_name }}"
rcvar="{{ service_name }}_enable"

load_rc_config {{ service_name }}
: ${{ '{' }}{{ service_name }}_enable:="NO"}

required_dirs="{{ directory }}"

# daemon
pidfile="/var/run/${name}.pid"
command=/usr/sbin/daemon
command_args="-cfp ${pidfile} sh -c 'cd {{ directory }}/server && node server.js'"
start_precmd="up1_precmd"

up1_precmd()
{
    install -o {{ user }} /dev/null ${pidfile}
}

PATH="${PATH}:/usr/local/bin"
run_rc_command "$1"
