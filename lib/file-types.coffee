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

  activate: (state) ->
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

  deactivate: ->
    o?() for o in @_off

  serialize: ->

  loadConfig: (config = {}) ->
    @debug = config.$debug is yes
    @caseSensitive = config.$caseSensitive is yes
    @snp = new ScopeNameProvider()
    for fileType, scopeName of config
      # Skip special settings
      # (hopefully this won't conflict with any file types)
      continue if /^\$/.test fileType

      # If `fileType` contains a dot, starts with a caret or forward slash,
      # or ends with a dollar, we assume it is a regular expression matcher
      if /(^\^)|(\.)|(\/)|(\$$)/.test fileType
        @snp.registerMatcher fileType, scopeName
      else
        # Otherwise, we assume it is an extension matcher
        @snp.registerExtension fileType, scopeName
    @_log @snp

  _tryToSetGrammar: (editor) ->
    path = editor.getPath()
    scopeName = @snp.getScopeName path, caseSensitive: @caseSensitive
    unless scopeName?
      @_log "no custom scopeName for #{path}...skipping"
      return
    g = atom.grammars.grammarForScopeName scopeName
    unless g?
      @_log "no grammar for #{scopeName}!?"
      return
    @_log "setting #{scopeName} as grammar for #{path}"
    editor.setGrammar g

  _log: (argv...) ->
    return unless @debug
    argv.unshift '[file-types]'
    console.debug.apply console, argv
