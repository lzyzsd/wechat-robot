expect = require('chai').expect
sinon = require 'sinon'

Rule = require '../src/rule'
Webot = require '../src/webot'
Message = require('../src/message').message
messageTypes = require('../src/message').messageTypes

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
      handler: ->

    textMessage = new Message
      ToUserName: 'bruce'
      FromUserName: 'test'
      CreateTime: Date.now
      MsgType: 'text'
      Content: 'hi'
      MsgId: 1

    webot.addRule rule

    webot.process(textMessage)
    .ensure ->
      expect(spy.called).to.equal true
      done()