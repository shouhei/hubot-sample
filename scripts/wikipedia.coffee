# Description:
#   Generate Wikipedia URL.
#
# Commands:
#   hubot wiki <query> - Generate Wikipedia URL

module.exports = (robot) ->
  robot.respond /wiki(?: (\S+))?/, (msg) ->
    WIKIPEDIA_URL = 'https://ja.wikipedia.org/wiki/' 
    msg.send WIKIPEDIA_URL + msg.match[1]