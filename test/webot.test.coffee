expect = require('chai').expect
sinon = require 'sinon'

Rule = require '../src/rule'
Webot = require '../src/webot'
Message = require '../src/message'
messageTypes = Message.messageTypes

describe 'Webot', ->
  webot = null
  beforeEach ->
    webot = new Webot

  it 'add rule', (done) ->
    rule = new Rule
      name: 'rule name'
      type: 'text'
      pattern: /hi/
    webot.addRule rule

    expect(webot.rules.length).to.equal 1
    done()

  it 'reset', (done) ->
    rule = new Rule
      name: 'rule name'
      type: 'text'
      pattern: /hi/
    webot.addRule rule

    webot.reset()

    expect(webot.rules.length).to.equal 0
    done()

  it 'Should before be called when process rules', (done) ->
    spy = sinon.spy()
    webot = new Webot
      before: spy

    rule = new Rule
      name: 'rule name'
      type: 'text'
      pattern:
        content: /hi/
      handler: (cb) -> cb null, 'welcome'

    textMessage = new Message
      ToUserName: 'bruce'
      FromUserName: 'test'
      CreateTime: Date.now
      MsgType: 'text'
      Content: 'hi'
      MsgId: 1

    webot.addRule rule

    webot.process(textMessage)
    .then (msg) ->
      expect(spy.called).to.equal true
      done()

  it 'Should after be called when process rules', (done) ->
    spy = sinon.spy()
    webot = new Webot
      after: spy

    rule = new Rule
      name: 'rule name'
      type: 'text'
      pattern:
        content: /hi/
      handler: (cb) -> cb null, 'welcome'

    textMessage = new Message
      ToUserName: 'bruce'
      FromUserName: 'test'
      CreateTime: Date.now
      MsgType: 'text'
      Content: 'hi'
      MsgId: 1

    webot.addRule rule

    webot.process(textMessage)
    .then (msg) ->
      expect(spy.called).to.equal true
      done()

  it 'Should after be called after before was called when process rules', (done) ->
    i = 0
    webot = new Webot
      after: -> expect(i).to.equal 1
      before: -> expect(i++).to.equal 0

    rule = new Rule
      name: 'rule name'
      type: 'text'
      pattern:
        content: /hi/
      handler: (cb) -> cb null, 'welcome'

    textMessage = new Message
      ToUserName: 'bruce'
      FromUserName: 'test'
      CreateTime: Date.now
      MsgType: 'text'
      Content: 'hi'
      MsgId: 1

    webot.addRule rule

    webot.process(textMessage)
    .then (msg) ->
      done()

  it 'Should before be called when process rules', (done) ->
    webot = new Webot()

    rule = new Rule
      name: 'rule name'
      type: 'text'
      pattern:
        content: /hi/
      handler: (cb) ->
        cb null, 'hi'

    textMessage = new Message
      ToUserName: 'bruce'
      FromUserName: 'test'
      CreateTime: Date.now
      MsgType: 'text'
      Content: 'hi'
      MsgId: 1

    webot.addRule rule

    webot.process(textMessage)
    .then (msg) ->
      expect(msg).to.not.be.null
      expect(msg).to.not.be.undefined
      done()
