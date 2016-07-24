{Minimatch} = require 'minimatch'

module.exports =
class Matcher
  constructor: (pattern, scopeName, opts = {}) ->
    @_matcher = new Minimatch pattern,
      matchBase: true
      nobrace: true
      nocomment: true
      nocase: !!opts.caseSensitive
      noext: true
      nonegate: true

  match: (string) ->
    @_matcher.match string

  toString: ->
    @_matcher.pattern
