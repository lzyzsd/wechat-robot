expect = require('chai').expect
sinon = require 'sinon'

Rule = require '../src/rule'
Message = require '../src/message'

describe 'Construct Rule', ->
  textRule =
    new Rule
      name: 'rule name'
      type: 'text'
      pattern:
        content: /hi/
      handler: (callback) ->
        replyMessage = 'welcome'
        callback null, replyMessage

  it 'string rule pattern', (done) ->
    rule = new Rule
      name: 'rule name'
      type: 'text'
      pattern: 'hi'
      handler: (cb) ->
        handlerCalled = true
        cb null, 'welcome'

    expect(rule.pattern).to.be.an.instanceof RegExp
    done()

  it 'string rule pattern', (done) ->
    pattern = /hi/
    rule = new Rule
      name: 'rule name'
      type: 'text'
      pattern: pattern
      handler: (cb) ->
        handlerCalled = true
        cb null, 'welcome'

    expect(rule.pattern).to.equal pattern
    done()

describe 'Rule', ->
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

    rule.process(textMessage).then (result) ->
      expect(handlerCalled).to.equal true
      done()

  it 'rule handler', (done) ->
    result = textRule.process(textMessage).then (message) ->
      expect(message).equal 'welcome'
      done()

describe 'Rule pattern', ->
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

  it 'string rule pattern', (done) ->
    result = textRule.process(textMessage).then (message) ->
      expect(message).equal 'welcome'
      done()