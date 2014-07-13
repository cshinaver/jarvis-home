# Switch server command
# Takes minecraft server name as argument
# and switches to new minecraft server
#
# Author: Charles Shinaver
#
#
#
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

  robot.respond /switch (\w+) to (\w+)$/i, (msg) ->
    process = msg.match[1]
    new_process = msg.match[2]
    status_command = (process) ->
      "/usr/local/bin/supervisorctl status #{process}"
    exec = require('child_process').exec

    stop_process = (process, callback) ->
      msg.send "Shutting down #{process}..."
      command = "/usr/local/bin/supervisorctl stop #{process}"
      exec command, (error, stdout, stderr) ->
        if error
          msg.send "There was an error.\n #{stdout}"
        else
          # Check if process sucessfully shut down
          exec (status_command process), (error, stdout, stderr) ->
            if error
              msg.send "There was an error #{error}"
            is_running = /RUNNING/.test(stdout)
            if not is_running
              msg.send "#{process} sucessfully shut down"
              # After status has been checked, run callback
            callback stdout
    
    start_process = (process) ->
      msg.send "Starting #{process}..."
      command = "/usr/local/bin/supervisorctl start #{process}"
      exec command, (error, stdout, stderr) ->
        if error
          msg.send "There was an error.\n #{stdout}"
        else
          # Check if process successfully started
          exec (status_command process), (error, stdout, stderr) ->
            is_running = /RUNNING/.test(stdout)
            if is_running
              msg.send "#{process} successfully started"
            else
              msg.send "Didn't start? \nstdout:#{stdout}\nerror:#{error}\nstderr:#{stderr}"
    
    # Switches processes
    exec (status_command process), (error, stdout, stderr) ->
      msg.send "Switching from #{process} to #{new_process}..."
      # Kill process if already running
      is_running = /RUNNING/.test(stdout)
      if is_running
        msg.send "#{process} is running."
        stop_process process, -> start_process new_process
   

