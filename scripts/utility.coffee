module.exports = (robot) ->
  robot.respond /lottery (.*)/i, (msg) ->
    result = msg.random msg.match[1].split(/\b/)
    msg.send result