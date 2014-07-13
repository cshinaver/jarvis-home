# Switch server command
# Takes minecraft server name as argument and switches to new minecraft server
#
# Author: Charles Shinaver
#
#
#
# Author:
#  Sapan Ganguly
#
command = "/usr/local/bin/supervisorctl status"
@exec = require('child_process').exec
full_command = "ssh -p2222 bijan@10429network.no-ip.org #{command}"
console.log full_command


@exec full_command, (error, stdout, stderr) ->
  if error
    console.log "oops"
  else
    console.log "success. #{stdout}"
