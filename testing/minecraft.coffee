# Switch server command
# Takes minecraft server name as argument
# and switches to new minecraft server
#
# Author: Charles Shinaver
#
#
#
# TODO: readd @ in front of exec
process = "dropbox"
status_command = "/usr/local/bin/supervisorctl status #{process}"
exec = require('child_process').exec
full_command = (command) ->
  "ssh -p2222 bijan@10429network.no-ip.org #{command}"

stop_process = (process) ->
  console.log "Shutting down process #{process}..."
  command = "/usr/local/bin/supervisorctl stop #{process}"
  console.log "Running this #{command}"
  exec (full_command command), (error, stdout, stderr) ->
    if error
      console.log "There was an error.\n #{stdout}"
    else
      console.log stdout
      console.log "#{process} sucessfully shut down"


# Checks status of given process
exec (full_command status_command), (error, stdout, stderr) ->
  is_running = /RUNNING/.test(stdout)
  if is_running
    console.log "#{process} is running."
    stop_process process


