request = require('request')
_ = require 'underscore'
config = require('./config')
levelup = require('levelup')

module.exports = (program) ->
  url = "https://graph.facebook.com/me/groups?access_token=#{ program.oauthToken }"
  request(url, (error, response, body) ->
    if error
      console.log error
      # Shut everything down if there's an error. Almost certainly it means
      # the token is wrong or Facebook's API is having trouble.
      process.exit()
    else
      console.log ''
      console.log ''
      groups = JSON.parse(body)
      sortedGroups = _.sortBy groups.data, (group) -> group['bookmark_order']
      for group in sortedGroups
        console.log group.name
        console.log "Group ID: #{ group.id }"
        console.log ''

        # Persist to DB
        config.groupsDb.put group.id, group
  )