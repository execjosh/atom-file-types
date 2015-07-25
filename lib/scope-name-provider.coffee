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
    @_matchers[scopeName] ?= []
    @_matchers[scopeName].push matcher
    @_scopeNames[scopeName] = scopeName
    return  # void

  getScopeName: (filename, opts = {}) ->
    ext = extname filename

    if opts.caseSensitive
      scopeName = @_exts[ext]
    else
      matches = Object.keys(@_exts).filter (e) ->
        e.toLowerCase() is ext.toLowerCase()
      if matches.length >= 1
        scopeName = @_exts[matches[0]]
        if matches.length > 1
          atom.notifications.addWarning '[file-types] Multiple Matches',
            detail: "Assuming '#{matches[0]}' (#{scopeName}) for file '#{filename}'."
            dismissable: true

    return scopeName if scopeName?

    @_matchFilename filename, opts

  getScopeNames: ->
    Object.keys @_scopeNames

  #
  # private
  #

  _matchFilename: (filename, opts = {}) ->
    for scopeName, matchers of @_matchers
      for matcher in matchers
        if opts.caseSensitive
          regexp = new RegExp matcher
        else
          regexp = new RegExp matcher, 'i'
        return scopeName if regexp.test filename
