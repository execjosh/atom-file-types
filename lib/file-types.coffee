{basename} = require 'path'

ScopeNameProvider = require './scope-name-provider'

CONFIG_KEY = 'file-types'

module.exports =
  config:
    $debug:
      type: 'boolean'
      default: no
    $caseSensitive:
      type: 'boolean'
      default: no

  debug: no

  snp: new ScopeNameProvider()

  _off: []

  _onceAllPackagesActivated: null

  activate: (state) ->
    unless @_onceAllPackagesActivated?
      @_onceAllPackagesActivated = atom.packages.onDidActivateInitialPackages =>
        @_initialize state

  deactivate: ->
    o?() for o in @_off
    @_onceAllPackagesActivated.dispose()
    @_onceAllPackagesActivated = null

  serialize: ->

  loadConfig: (config = {}) ->
    @debug = config.$debug is yes
    @caseSensitive = config.$caseSensitive is yes
    @snp = new ScopeNameProvider()
    for fileType, scopeName of config
      # Skip special settings
      # (hopefully this won't conflict with any file types)
      continue if /^\$/.test fileType

      @snp.registerMatcher fileType, scopeName, caseSensitive: @caseSensitive
    @_log @snp

  _initialize: (state) ->
    @_off.push atom.config.observe CONFIG_KEY, (newValue) =>
      @loadConfig newValue
      for editor in atom.workspace.getTextEditors()
        @_tryToSetGrammar editor

    @_off.push atom.workspace.observeTextEditors (editor) =>
      # TODO: Does this cause a memory leak?
      @_off.push editor.onDidChangePath =>
        @_tryToSetGrammar editor
      @_tryToSetGrammar editor

    # Update all editors whenever a grammar registered with us gets loaded
    updateEditorGrammars = (g) =>
      for scopeName in @snp.getScopeNames() when g.scopeName is scopeName
        for editor in atom.workspace.getTextEditors()
          @_tryToSetGrammar editor

    @_off.push atom.grammars.onDidAddGrammar updateEditorGrammars
    @_off.push atom.grammars.onDidUpdateGrammar updateEditorGrammars

  _tryToSetGrammar: (editor) ->
    fullPath = editor.getPath()
    return unless fullPath?
    filename = basename fullPath
    scopeName = @snp.getScopeName filename
    unless scopeName?
      @_log "no custom scopeName for #{filename}...skipping"
      return
    g = atom.grammars.grammarForScopeName scopeName
    unless g?
      @_log "no grammar for #{scopeName}!?"
      return
    @_log "setting #{scopeName} as grammar for #{filename}"
    editor.setGrammar g

  _log: (argv...) ->
    return unless @debug
    argv.unshift '[file-types]'
    console.debug.apply console, argv
