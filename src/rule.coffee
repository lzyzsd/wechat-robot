whenjs = require 'when'

messageTypes = require('./message').messageTypes

class Rule
  constructor: (options) ->
    @name = options.name
    @type = options.type
    @pattern = options.pattern
    @isFullMatch = options.isFullMatch or true #默认为完全匹配
    @isIgnoreCase = options.isIgnoreCase or true #默认大小写不敏感
    @handler = options.handler
    @_preprocessPattern()

  _convertString2Reg: (content) ->
    content = content.trim()
    if @isFullMatch
      if content[0] isnt '^' then content = '^' + content
      if content[content.length-1] isnt '$' then content += '$'
    if @isIgnoreCase then new RegExp content, 'i' else new RegExp content

  _preprocessPatternProperty: (propertyName) ->
    if @pattern[propertyName]
      if typeof @pattern[propertyName] is 'string'
        @pattern[propertyName] = @_convertString2Reg @pattern[propertyName]
      else if @pattern[propertyName] instanceof Function
        return
      else if @pattern[propertyName] instanceof RegExp
        return
      else
        throw Error 'rule pattern type not supported'
    else
      throw Error "can not find #{propertyName} property in rule pattern for text message"

  _preprocessPattern4TextMessage: ->
    type = typeof @pattern
    switch type
      when 'function' then return
      when 'string' then @pattern = @_convertString2Reg @pattern
      when 'object'
        return if @pattern instanceof RegExp
        @_preprocessPatternProperty 'content'
      else
        throw Error 'unsupported pattern type, pattern can only be type of [string, object, function]'

  _preprocessPattern4EventMessage: ->
    throw Error 'rule pattern for event message should be object.' if typeof @pattern isnt 'object'
    @_preprocessPatternProperty 'event'
    @_preprocessPatternProperty 'eventKey'

  _preprocessPattern: ->
    switch @type
      when messageTypes.text
        @_preprocessPattern4TextMessage()
      when messageTypes.event
        @_preprocessPattern4EventMessage()

  match: (message) ->
    return false if message.type isnt @type
    switch message.type
      when messageTypes.text then @_matchTextMessage message
      when messageTypes.event then @_matchEventMessage message
      else false

  _matchTextMessage: (message) ->
    type = typeof @pattern
    if type is 'function'
      @pattern message.content
    else
      #object
      if @pattern instanceof RegExp
        @pattern.test message.content
      else
        if @pattern.content instanceof RegExp
          @pattern.content.test message.content
        else
          @pattern.content message.content

  _matchEventMessage: (message) ->
    if typeof @pattern.event is 'function'
      isEventMatched = @pattern.event message.event
    else
      isEventMatched = @pattern.event.test message.event

    if typeof @pattern.eventKey is 'function'
      isEventKeyMatched = @pattern.eventKey message.eventKey
    else
      isEventKeyMatched = @pattern.eventKey.test message.eventKey

    isEventMatched and isEventKeyMatched

  process: (message) ->
    deferred = whenjs.defer()
    if @match message
      @handler (err, msg) ->
        if err then deferred.reject err else deferred.resolve msg
    else
      deferred.reject 'unmatched'
    deferred.promise

module.exports = Rule