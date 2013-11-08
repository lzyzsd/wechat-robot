messageTypes =
  text: 'text'
  event: 'event'
  location: 'location'
  link: 'link'
  image: 'image'

class Message
  # ToUserName
  # FromUserName
  # CreateTime
  # MsgType
  # MsgId
  constructor: (options) ->
    @toUserName = options.ToUserName
    @fromUserName = options.FromUserName
    @xreateTime = options.CreateTime
    @type = options.MsgType
    @id = options.MsgId
    switch @type
      when messageTypes.text
        @content = options.Content
      when messageTypes.event
        @event = options.Event
        @eventKey = options.EventKey
      when messageTypes.location
        @locationX = options.Location_X
        @locationY = options.Location_Y
        @scale = options.Scale
        @label = options.Label
      when messageTypes.link
        @title = options.Title
        @description = options.Description
        @url = options.url
      when messageTypes.image
        @picUrl = options.PicUrl
      else throw Error('不支持的类型')

  # match: (rule) ->
  #   return false if rule.type isnt @type
  #   switch @type
  #     when messageTypes.text then rule.pattern.content.test @content
  #     when messageTypes.event then (rule.pattern.event is @event) and (rule.pattern.eventKey is @eventKey)
  #     # when messageTypes.image then rule.pattern.picUrl is
  #     else false

module.exports =
  message: Message
  messageTypes: messageTypes