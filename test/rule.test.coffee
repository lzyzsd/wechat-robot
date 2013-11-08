expect = require('chai').expect
sinon = require 'sinon'

Rule = require '../src/rule'
Message = require('../src/message').message

describe 'Webot', ->
  textRule =
    new Rule
      name: 'rule name'
      type: 'text'
      pattern:
        content: /hi/
      handler: (callback) ->
        replyMessage = 'welcome'
        callback null, replyMessage

  textMessage =
    new Message
      ToUserName: 'bruce'
      FromUserName: 'test'
      CreateTime: Date.now
      MsgType: 'text'
      Content: 'hi'
      MsgId: 1

  it 'match text message', (done) ->
    rule = new Rule
      name: 'rule name'
      type: 'text'
      pattern:
        content: /hi/

    textMessage = new Message
      ToUserName: 'bruce'
      FromUserName: 'test'
      CreateTime: Date.now
      MsgType: 'text'
      Content: 'hi'
      MsgId: 1

    result = rule.match textMessage
    expect(result).to.equal true
    done()

  it 'match event message', (done) ->
    rule = new Rule
      name: 'rule name'
      type: 'event'
      pattern:
        event: 'EVENT'
        eventKey: 'subscribe'

    eventMessage = new Message
      ToUserName: 'bruce'
      FromUserName: 'test'
      CreateTime: Date.now
      MsgType: 'event'
      Event: 'EVENT'
      EventKey: 'subscribe'
      MsgId: 1

    result = rule.match eventMessage
    expect(result).to.equal true
    done()

  it 'match image message', (done) ->
    rule = new Rule
      name: 'rule name'
      type: 'image'
      pattern:
        event: 'EVENT'
        eventKey: 'subscribe'

    imageMessage = new Message
      ToUserName: 'bruce'
      FromUserName: 'test'
      CreateTime: Date.now
      MsgType: 'image'
      Event: 'EVENT'
      EventKey: 'subscribe'
      MsgId: 1

    result = rule.match imageMessage
    expect(result).to.equal false
    done()

  it 'Should rule handler be called', (done) ->
    handlerCalled = false
    rule = new Rule
      name: 'rule name'
      type: 'text'
      pattern:
        content: /hi/
      handler: (cb) ->
        handlerCalled = true
        cb null, 'welcome'

    textMessage = new Message
      ToUserName: 'bruce'
      FromUserName: 'test'
      CreateTime: Date.now
      MsgType: 'text'
      Content: 'hi'
      MsgId: 1

    rule.process(textMessage).then (result) ->
      expect(handlerCalled).to.equal true
      done()

  it 'rule handler', (done) ->
    result = textRule.process(textMessage).then (message) ->
      expect(message).equal 'welcome'
      done()