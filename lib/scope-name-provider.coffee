{basename,extname,sep} = require 'path'

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

  getScopeName: (path, opts = {}) ->
    ext = extname path

    if opts.caseSensitive
      scopeName = @_exts[ext]
    else
      matches = Object.keys(@_exts).filter (e) ->
        e.toLowerCase() is ext.toLowerCase()
      if matches.length >= 1
        scopeName = @_exts[matches[0]]
        if matches.length > 1
          atom.notifications.addWarning '[file-types] Multiple Matches',
            detail: "Assuming '#{matches[0]}' (#{scopeName}) for file '#{path}'."
            dismissable: true

    return scopeName if scopeName?

    @_matchFilename path, opts

  getScopeNames: ->
    Object.keys @_scopeNames

  #
  # private
  #

  _matchFilename: (path, opts = {}) ->
    regexpOptions = if opts.caseSensitive then 'i' else ''
    filename = basename path
    for scopeName, matchers of @_matchers
      for matcher in matchers
        if matcher.charAt 0 == '/'
          if sep == '\\'
            matcher = matcher.replace('/', '\\\\')
          regexp = new RegExp matcher, regexpOptions
          return scopeName if regexp.test path
        regexp = new RegExp matcher, regexpOptions
        return scopeName if regexp.test filename
