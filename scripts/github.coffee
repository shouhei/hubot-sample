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
        json = JSON.parse body
        if json.message == "Not Found"
          url = "https://api.bitbucket.org/2.0/repositories/#{target}/"
          msg.http(url).get() (bit_err, bit_res, bit_body) ->
            bit_json = JSON.parse bit_body
            if bit_json.type == "error"
              msg.send bit_json.error.message
            else
              time_str = bit_json.values[0].updated_on.replace(/T/," ")
              time_str = time_str.replace(/Z/," UTC")
              time = new Date time_str
              now = new Date
              if time.getDate() == now.getDate()
                msg.send ":white_check_mark: <" + bit_json.values[0].owner.links.html.href + "|"  + bit_json.values[0].owner.display_name + "> : " + time
                robot.logger.info "#{request_guid}: Bitbucket commited response has send."
              else
                msg.send ":warning: <" + bit_json.values[0].owner.links.html.href + "|"  + bit_json.values[0].owner.display_name + "> : " + time
                robot.logger.info "#{request_guid}: Bitbucket not commited response has send."
        else
          for event in json
            if event.type == "PushEvent"
              time_str = json[0].created_at.replace(/T/," ")
              time_str = time_str.replace(/Z/," UTC")
              time = new Date time_str
              now = new Date
              if time.getDate() == now.getDate()
                msg.send ":white_check_mark: <" + event.actor.url.replace(/api\.|users(?=\/)/g,"") + "|" + event.payload.commits[0].author.name + "> : " + time
                robot.logger.info "#{request_guid}: Github commited response has send."
              else
                msg.send ":warning: <" + event.actor.url.replace(/api\.|users(?=\/)/g,"") + "|" + event.payload.commits[0].author.name + "> : " + time
                robot.logger.info "#{request_guid}: Gtihub not commited response has send."
              return false
