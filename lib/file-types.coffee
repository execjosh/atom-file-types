{basename, extname} = require 'path'
_ = require 'underscore-plus'

CONFIG_KEY = 'file-types'

module.exports =
  configDefaults:
    $debug: no

  debug: no

  fileTypes: {}

  _off: []

  activate: (state) ->
    @_off.push atom.config.observe CONFIG_KEY, (newValue) =>
      @loadConfig newValue
      for editor in atom.workspace.getEditors()
        @_tryToSetGrammar editor

    @_off.push atom.workspaceView.eachEditorView (view) =>
      editor = view.getEditor()
      # TODO: Does this cause a memory leak?
      @_off.push editor.on 'path-changed', =>
        @_tryToSetGrammar editor
      @_tryToSetGrammar editor

    @_off.push atom.syntax.on 'grammar-added', (g) =>
      for fileType, scopeName of @fileTypes when g.scopeName is scopeName
        for editor in atom.workspace.getEditors()
          @_tryToSetGrammar editor

  deactivate: ->
    o?() for o in @_off

  serialize: ->

  loadConfig: (config = {}) ->
    config = _.extend {}, @configDefaults, config
    @debug = config.$debug is yes
    @fileTypes = {}
    for fileType, scopeName of config
      # Skip special settings
      # (hopefully this won't conflict with any file types)
      continue if /^\$/.test fileType
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
