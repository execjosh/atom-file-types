ScopeNameProvider = require '../lib/scope-name-provider'

describe 'ScopeNameProvider', ->
  [snp] = []

  beforeEach ->
    snp = new ScopeNameProvider()
    @addMatchers
      toEqualNull: -> `this.actual == null`

  describe 'scope provision', ->
    it 'provides scope name based on file extension', ->
      snp.registerMatcher 'blah', 'text.plain.test-grammar'
      expect(snp.getScopeName 'hogehoge.blah').toBe 'text.plain.test-grammar'

    it 'provides scope name based on regexp matcher', ->
      snp.registerMatcher 'spec\\.coffee$', 'test.coffee.spec'
      expect(snp.getScopeName 'super-human-spec.coffee').toBe 'test.coffee.spec'

    it 'gives precedence to longest match', ->
      snp.registerMatcher 'blah', 'text.plain.test-grammar'
      snp.registerMatcher 'spec\\.blah$', 'test.blah.spec'
      expect(snp.getScopeName 'super-human-spec.blah').toBe 'test.blah.spec'

    it 'gives precedence to last match for match length tie-breaker', ->
      snp.registerMatcher 'rb', 'text.plain.test-grammar'
      snp.registerMatcher '\\.r(a|b)$', 'test.blah.spec'
      expect(snp.getScopeName 'super-human-spec.rb').toBe 'test.blah.spec'

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

      it 'can match escaped dots', ->
        snp.registerMatcher '_spec\\.rb$', 'source.ruby.rspec'
        expect(snp.getScopeName 'really_cool_controller_spec.rb').toBe 'source.ruby.rspec'

  describe 'registered scope name list provision', ->
    it 'initially has no scope names', ->
      expect(snp.getScopeNames()).toEqual []

    it 'updates the list as grammars are added', ->
      snp.registerMatcher 'blah', 'text.plain.test-grammar'
      expect(snp.getScopeNames()).toEqual ['text.plain.test-grammar']

      snp.registerMatcher 'hogehoge', 'text.plain.null-grammar'
      expect(snp.getScopeNames()).toEqual ['text.plain.test-grammar', 'text.plain.null-grammar']

    it 'provides a list of unique grammars', ->
      snp.registerMatcher 'blah', 'text.plain.test-grammar'
      expect(snp.getScopeNames()).toEqual ['text.plain.test-grammar']

      snp.registerMatcher 'blah', 'text.plain.test-grammar'
      expect(snp.getScopeNames()).toEqual ['text.plain.test-grammar']
