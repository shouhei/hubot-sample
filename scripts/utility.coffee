module.exports = (robot) ->
  robot.respond /lottery(?: (\S+))?/, (msg) ->
    msg.send msg.random msg.match