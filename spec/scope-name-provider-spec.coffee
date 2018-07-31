ScopeNameProvider = require '../lib/scope-name-provider'

describe 'ScopeNameProvider', ->
  [snp] = []

  beforeEach ->
    snp = new ScopeNameProvider()
    @addMatchers
      toEqualNull: -> `this.actual == null`

  describe 'scope provision', ->
    it 'provides scope name based on file extension', ->
      snp.registerMatcher '*.blah', 'text.plain.test-grammar'
      expect(snp.getScopeName 'hogehoge.blah').toBe 'text.plain.test-grammar'

    it 'provides scope name based on regexp matcher', ->
      snp.registerMatcher '*spec.coffee', 'test.coffee.spec'
      expect(snp.getScopeName 'super-human-spec.coffee').toBe 'test.coffee.spec'

    it 'gives precedence to longest match', ->
      matchers =
        '*.css.liquid': 'source.css'
        '*.scss.liquid': 'source.css.scss'
        '*.liquid': 'text.html.basic'
        '*_spec.rb': 'source.ruby.rspec'
        '*.rb': 'source.ruby'
      for pattern, scopeName of matchers
        snp.registerMatcher pattern, scopeName
      expect(snp.getScopeName 'some_controller_spec.rb').toBe 'source.ruby.rspec'
      expect(snp.getScopeName 'some_controller.rb').toBe 'source.ruby'
      expect(snp.getScopeName 'something.liquid').toBe 'text.html.basic'
      expect(snp.getScopeName 'something.scss.liquid').toBe 'source.css.scss'
      expect(snp.getScopeName 'something.css.liquid').toBe 'source.css'

    describe 'globbing matcher', ->
      it 'can match start-of-string', ->
        snp.registerMatcher 'spec*', 'test.spec'
        expect(snp.getScopeName 'spec-super-human.coffee').toBe 'test.spec'
        expect(snp.getScopeName 'super-human-spec.coffee').toEqualNull()

      it 'can match mid-string', ->
        snp.registerMatcher 'sp*.coffee', 'test.spec'
        expect(snp.getScopeName 'spec-super-human.coffee').toBe 'test.spec'
        expect(snp.getScopeName 'super-human-spec.coffee').toEqualNull()
        expect(snp.getScopeName 'super-human-spock.coffee').toEqualNull()

      it 'can match end-of-string', ->
        snp.registerMatcher '*spec', 'test.spec'
        expect(snp.getScopeName 'spec-super-human').toEqualNull()
        expect(snp.getScopeName 'super-human-spec').toBe 'test.spec'

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
