module.exports = (robot) ->
  robot.respond /pushed (.*)/i, (msg) ->
    target = msg.match[1]
    request = msg.http("https://api.github.com/users/#{target}/events").get()

    request (err, res, body) ->
      json = JSON.parse body
      time_str = json[0].created_at.replace(/T/," ")
      time_str = time_str.replace(/Z/," UTC")
      time = new Date time_str
      now = new Date

      if time.getDate() == now.getDate()
        msg.send ":white_check_mark: " + target + " : " + time
      else
        msg.send ":warning: " + target + " : " + time
  
  robot.hear /pushedList (.*)/i, (msg) ->
    targets = msg.match[1].replace(/\.$/,"")
    targets = targets.split(/\s/)
    for target in targets
      url = "https://api.github.com/users/#{target}/events"
      request = msg.http(url).get()

      request (err, res, body) ->
        json = JSON.parse body
        for event in json
          if event.type == "PushEvent"
            time_str = json[0].created_at.replace(/T/," ")
            time_str = time_str.replace(/Z/," UTC")
            time = new Date time_str
            now = new Date
            if time.getDate() == now.getDate()
              msg.send ":white_check_mark: " + event.payload.commits[0].author.name + " : " + time
            else
              msg.send ":warning: " + event.payload.commits[0].author.name + " : " + time
            break