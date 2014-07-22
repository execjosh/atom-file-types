ScopeNameProvider = require '../lib/scope-name-provider'

describe 'ScopeNameProvider', ->
  [snp] = []

  beforeEach ->
    snp = new ScopeNameProvider()
    @addMatchers
      toEqualNull: -> `this.actual == null`

  describe 'scope provision', ->
    it 'provides scope name based on file extension', ->
      snp.registerExtension 'blah', 'text.plain.test-grammar'
      expect(snp.getScopeName 'hogehoge.blah').toBe 'text.plain.test-grammar'

    it 'provides scope name based on regexp matcher', ->
      snp.registerMatcher 'spec\.coffee$', 'test.coffee.spec'
      expect(snp.getScopeName 'super-human-spec.coffee').toBe 'test.coffee.spec'

    it 'gives precedence to file extension above regexp matchers', ->
      snp.registerExtension 'blah', 'text.plain.test-grammar'
      snp.registerMatcher 'spec\.blah$', 'test.blah.spec'
      expect(snp.getScopeName 'super-human-spec.blah').toBe 'text.plain.test-grammar'

    describe 'regexp matcher', ->
      it 'can match start-of-string', ->
        snp.registerMatcher '^spec', 'test.spec'
        expect(snp.getScopeName 'spec-super-human.coffee').toBe 'test.spec'
        expect(snp.getScopeName 'super-human-spec.coffee').toEqualNull()

      it 'can match mid-string', ->
        snp.registerMatcher 'sp.c', 'test.spec'
        expect(snp.getScopeName 'spec-super-human.coffee').toBe 'test.spec'
        expect(snp.getScopeName 'super-human-spec.coffee').toBe 'test.spec'
        expect(snp.getScopeName 'super-human-spock.coffee').toBe 'test.spec'

      it 'can match end-of-string', ->
        snp.registerMatcher 'spec$', 'test.spec'
        expect(snp.getScopeName 'spec-super-human').toEqualNull()
        expect(snp.getScopeName 'super-human-spec').toBe 'test.spec'

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
