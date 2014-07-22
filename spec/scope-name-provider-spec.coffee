ScopeNameProvider = require '../lib/scope-name-provider'

describe 'ScopeNameProvider', ->
  [snp] = []

  beforeEach ->
    snp = new ScopeNameProvider()

  describe 'scope provision', ->
    it 'provides scope name based on file extension', ->
      snp.registerExtension 'blah', 'text.plain.test-grammar'
      expect(snp.getScopeName 'hogehoge.blah').toBe 'text.plain.test-grammar'

  describe 'registered scope name list provision', ->
    it 'initially has no scope names', ->
      expect(snp.getScopeNames()).toEqual []

    it 'updates the list as grammars are added', ->
      snp.registerExtension 'blah', 'text.plain.test-grammar'
      expect(snp.getScopeNames()).toEqual ['text.plain.test-grammar']

      snp.registerExtension 'hogehoge', 'text.plain.null-grammar'
      expect(snp.getScopeNames()).toEqual ['text.plain.test-grammar', 'text.plain.null-grammar']

    it 'provides a list of unique grammars', ->
      snp.registerExtension 'blah', 'text.plain.test-grammar'
      expect(snp.getScopeNames()).toEqual ['text.plain.test-grammar']

      snp.registerExtension 'blah', 'text.plain.test-grammar'
      expect(snp.getScopeNames()).toEqual ['text.plain.test-grammar']
