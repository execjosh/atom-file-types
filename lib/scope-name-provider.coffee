{extname} = require 'path'

module.exports =
class ScopeNameProvider
  constructor: ->
    @_exts = {}
    @_matchers = {}
    @_scopeNames = {}

  registerExtension: (ext, scopeName) ->
    @_exts[".#{ext}"] = scopeName
    @_scopeNames[scopeName] = scopeName
    return  # void

  registerMatcher: (matcher, scopeName) ->
    regexp = new RegExp matcher
    @_matchers[scopeName] ?= []
    @_matchers[scopeName].push regexp
    @_scopeNames[scopeName] = scopeName
    return  # void

  getScopeName: (filename) ->
    ext = extname filename
    scopeName = @_exts[ext]
    return scopeName if scopeName?

    @_matchFilename filename

  getScopeNames: ->
    Object.keys @_scopeNames

  #
  # private
  #

  _matchFilename: (filename) ->
    for scopeName, matchers of @_matchers
      for matcher in matchers
        return scopeName if matcher.test filename
