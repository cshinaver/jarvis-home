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

 robot.respond /switch server from (.*) to (.*)$/i, (msg) ->
    stop_server = msg.match[1]
    start_server = msg.match[2]
    @exec = require('child_process').exec
    stop_command = "/usr/local/bin/supervisorctl stop #{stop_server}"
    

    msg.send "Stopping #{stop_server}..."

    @exec stop_command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr
