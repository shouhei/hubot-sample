# Description:
#   Check today's push.
#
# Commands:
#   hubot pushed <query> - Check today's push

guid = ->
  s4 = ->
    Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)
  s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()

module.exports = (robot) ->
  robot.hear ///#{robot.name}\s+pushed\s+(.*)///i, (msg) ->
    request_guid = guid()
    robot.logger.info "#{request_guid}: Request has comming."
    robot.logger.info "#{request_guid}: Params #{msg.match[1]}"
    targets = msg.match[1].replace(/\.$/,"")
    targets = targets.split(/\s/)
    for target in targets
      url = "https://api.github.com/users/#{target}/events"
      msg.http(url).get() (err, res, body) ->
        if err
          return msg.send ":white_check_mark: < Request was failed. Please check GitHub status. > : " + time

        robot.logger.info "#{request_guid}: GitHub Response #{body}"
        json = JSON.parse body
        for event in json
          if event.type == "PushEvent"
            time = new Date json[0].created_at.replace(/T/," ").replace(/Z/," UTC")
            now = new Date
            if time.getDate() == now.getDate()
              msg.send ":white_check_mark: <" + event.actor.url.replace(/api\.|users(?=\/)/g,"") + "|" + event.payload.commits[0].author.name + "> : " + time
              robot.logger.info "#{request_guid}: Github commited response has send."
            else
              msg.send ":warning: <" + event.actor.url.replace(/api\.|users(?=\/)/g,"") + "|" + event.payload.commits[0].author.name + "> : " + time
              robot.logger.info "#{request_guid}: Gtihub not commited response has send."
            return false
