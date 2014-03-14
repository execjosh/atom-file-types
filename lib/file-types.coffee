{basename, extname} = require 'path'

module.exports =
  debug: true

  fileTypes: {}

  activate: (state) ->
    @_off = atom.workspaceView.eachEditorView (view) =>
      @loadConfig atom.config.get 'file-types'
      editor = view.getEditor()
      @_tryToSetGrammar editor

  deactivate: ->
    @_off?()

  serialize: ->

  loadConfig: (config = {}) ->
    @fileTypes = {}
    for fileType, scopeName of config
      @fileTypes[".#{fileType}"] = scopeName
    @_log @fileTypes

  _tryToSetGrammar: (editor) ->
    filename = basename editor.getPath()
    ext = extname filename
    unless ext
      @_log 'no extension...skipping'
      return
    scopeName = @fileTypes[ext]
    unless scopeName?
      @_log "no custom scopeName for #{ext}...skipping"
      return
    g = atom.syntax.grammarForScopeName scopeName
    unless g?
      @_log "no grammar for #{scopeName}!?"
      return
    @_log "setting #{scopeName} as grammar for #{filename}"
    editor.setGrammar g

  _log: (argv...) ->
    return unless @debug
    argv.unshift '[file-types]'
    console.debug.apply console, argv
