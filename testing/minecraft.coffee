# Description:
#  Execute a shell command if you can't be bothered to learn coffee script.
#  This particular example just does a DNS lookup.
#
# Dependencies:
#  None
#
# Configuration
#  Change the script if you want to exeute a different command
#
# Commands:
#  hubot host lookup <hostname>
#
# Author:
#  Sapan Ganguly
#
command = "ls"
@exec = require('child_process').exec
full_command = "ssh -p2222 bijan@10429network.no-ip.org #{command}"
console.log full_command


@exec full_command, (error, stdout, stderr) ->
    if error
        console.log "oops"
    else
        console.log "success. #{stdout}"
