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
    exec = require('child_process').exec
    pixelmon_command = "/usr/local/bin/supervisorctl status"
    

    msg.send "Looking up full server status..."

    exec pixelmon_command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

  robot.respond /switch server from (.*) to (.*)$/i, (msg) ->
    process = "dropbox"
    new_process = "transmission"
    status_command = (process) ->
      "/usr/local/bin/supervisorctl status #{process}"
    exec = require('child_process').exec
    full_command = (command) ->
      "ssh -p2222 bijan@10429network.no-ip.org #{command}"
    
    stop_process = (process, callback) ->
      console.log "Shutting down #{process}..."
      command = "/usr/local/bin/supervisorctl stop #{process}"
      exec (full_command command), (error, stdout, stderr) ->
        if error
          console.log "There was an error.\n #{stdout}"
        else
          # Check if process sucessfully shut down
          exec (full_command (status_command process)), (error, stdout, stderr) ->
            if error
              console.log "There was an error #{error}"
            is_running = /RUNNING/.test(stdout)
            if not is_running
              console.log "#{process} sucessfully shut down"
              # After status has been checked, run callback
            callback stdout
    
    start_process = (process) ->
      console.log "Starting #{process}"
      command = "/usr/local/bin/supervisorctl start #{process}"
      exec (full_command command), (error, stdout, stderr) ->
        if error
          console.log "There was an error.\n #{stdout}"
        else
          # Check if process successfully started
          exec (full_command (status_command process)), (error, stdout, stderr) ->
            is_running = /RUNNING/.test(stdout)
            if is_running
              console.log "stdout #{stdout}"
              console.log "#{process} successfully started"
            else
              console.log "Didn't start? \nstdout:#{stdout}\nerror:#{error}\nstderr:#{stderr}"
    
    # Switches processes
    exec (full_command (status_command process)), (error, stdout, stderr) ->
      # Kill process if already running
      is_running = /RUNNING/.test(stdout)
      if is_running
        console.log "#{process} is running."
        stop_process process, => start_process new_process
   

