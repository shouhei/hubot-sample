# Description:
#   Check current train status.
#
# Commands:
#   hubot train status line


htmlparser = require "htmlparser2"

module.exports = (robot) ->
  robot.hear ///#{robot.name}\s+train\s+status\s+odakyu///i, (msg) ->
      url = "http://www.odakyu.jp/cgi-bin/user/emg/emergency_bbs.pl"
      trainState = false
      msg.http(url).get() (err, res, body) ->
        if err
            return msg.send "parse error"
        parser = new htmlparser.Parser({
            onopentag: (name, attribs) ->
                if attribs.class == "ttl_daiya_blue"
                    trainState = true
                    return msg.send "正常"
        }, {decodeEntities: true});
        parser.write(body)
        if trainState = false
            return msg.send "異常"
