# Description:
#   Draw from query.
#
# Commands:
#   hubot lottery <query> - Draw from query

module.exports = (robot) ->
  robot.respond /lottery (.*)/i, (msg) ->
    result = msg.random msg.match[1].split(/\s/)
    msg.send result