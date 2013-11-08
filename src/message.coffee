class Message
  # ToUserName
  # FromUserName
  # CreateTime
  # MsgType
  # MsgId
  @messageTypes:
    text: 'text'
    event: 'event'
    location: 'location'
    link: 'link'
    image: 'image'
  constructor: (options) ->
    @toUserName = options.ToUserName
    @fromUserName = options.FromUserName
    @xreateTime = options.CreateTime
    @type = options.MsgType
    @id = options.MsgId
    switch @type
      when Message.messageTypes.text
        @content = options.Content
      when Message.messageTypes.event
        @event = options.Event
        @eventKey = options.EventKey
      when Message.messageTypes.location
        @locationX = options.Location_X
        @locationY = options.Location_Y
        @scale = options.Scale
        @label = options.Label
      when Message.messageTypes.link
        @title = options.Title
        @description = options.Description
        @url = options.url
      when Message.messageTypes.image
        @picUrl = options.PicUrl
      else throw Error('不支持的类型')

module.exports = Message