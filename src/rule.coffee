whenjs = require 'when'

messageTypes = require('./message').messageTypes

class Rule
  constructor: (options) ->
    @name = options.name
    @type = options.type
    @pattern = options.pattern
    @isFullMatch = options.isFullMatch or true #默认为完全匹配
    @handler = options.handler

  match: (message) ->
    return false if message.type isnt @type
    switch message.type
      when messageTypes.text then @pattern.content.test message.content
      when messageTypes.event then (@pattern.event is message.event) and (@pattern.eventKey is message.eventKey)
      # when messageTypes.image then rule.pattern.picUrl is
      else false

  process: (message) ->
    deferred = whenjs.defer()
    if @match message
      @handler (err, msg) ->
        if err then deferred.reject err else deferred.resolve msg
    else
      deferred.reject 'unmatched'
    deferred.promise

module.exports = Rule