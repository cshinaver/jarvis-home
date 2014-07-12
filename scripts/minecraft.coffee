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

module.exports = (robot) ->
 robot.respond /server status$/i, (msg) ->
    @exec = require('child_process').exec
    pixelmon_command = "/usr/local/bin/supervisorctl status"
    

    msg.send "Looking up full server status..."

    @exec pixelmon_command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

