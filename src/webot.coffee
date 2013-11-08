whenjs = require 'when'
Rule = require './rule'
Message = require './message'

class Webot
  constructor: (options={}) ->
    @rules = []
    @before = options.before
    @after = options.after


  addRule: (rule) ->
    @rules.push rule

  reset: -> @rules.length = 0

  process: (message) ->
    deferred = whenjs.defer()
    @before?(message)

    whenjs.all(@_process message)
    .then (results) =>
      reply = r for r in results when r? and r isnt 'undefined'
      deferred.resolve reply
      @after? message, reply
    , ->
      deferred.reject()
    .ensure @after

    deferred.promise

  _process: (message) ->
    deferreds = []
    for rule in @rules
      deferreds.push rule.process(message)

    deferreds

module.exports = Webot