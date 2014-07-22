{extname} = require 'path'

module.exports =
class ScopeNameProvider
  constructor: ->
    @_exts = {}
    @_scopeNames = {}

  registerExtension: (ext, scopeName) ->
    @_exts[".#{ext}"] = scopeName
    @_scopeNames[scopeName] = scopeName
    return  # void

  getScopeName: (filename) ->
    ext = extname filename
    @_exts[ext]

  getScopeNames: ->
    Object.keys @_scopeNames
