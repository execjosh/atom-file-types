{basename} = require 'path'
_ = require 'underscore-plus'

ScopeNameProvider = require './scope-name-provider'

CONFIG_KEY = 'file-types'

module.exports =
  configDefaults:
    $debug: no

  debug: no

  snp: new ScopeNameProvider()

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

    # Update all editors whenever a grammar registered with us gets loaded
    @_off.push atom.syntax.on 'grammar-added', (g) =>
      for scopeName in @snp.getScopeNames() when g.scopeName is scopeName
        for editor in atom.workspace.getEditors()
          @_tryToSetGrammar editor

  deactivate: ->
    o?() for o in @_off

  serialize: ->

  loadConfig: (config = {}) ->
    config = _.extend {}, @configDefaults, config
    @debug = config.$debug is yes
    @snp = new ScopeNameProvider()
    for fileType, scopeName of config
      # Skip special settings
      # (hopefully this won't conflict with any file types)
      continue if /^\$/.test fileType

      # If `fileType` contains a dot, starts with a caret, or ends with a dollar,
      # we assume it is a regular expression matcher
      if /(^\^)|(\.)|(\$$)/.test fileType
        @snp.registerMatcher fileType, scopeName
      else
        # Otherwise, we assume it is an extension matcher
        @snp.registerExtension fileType, scopeName
    @_log @snp

  _tryToSetGrammar: (editor) ->
    filename = basename editor.getPath()
    scopeName = @snp.getScopeName filename
    unless scopeName?
      @_log "no custom scopeName for #{filename}...skipping"
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
