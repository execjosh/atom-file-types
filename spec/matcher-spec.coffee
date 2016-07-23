Matcher = require '../lib/matcher'

describe 'Matcher', ->
  describe 'constructor', ->
    it 'creates null regexp for null input', ->
      matcher = new Matcher null
      expect(matcher._regexp).toBe null

    it 'creates null regexp for empty input', ->
      matcher = new Matcher ''
      expect(matcher._regexp).toBe null

    describe 'with carat (^)', ->
      it 'creates regexp for input starting with a carat (^)', ->
        matcher = new Matcher '^rb'
        expect(matcher._regexp.toString()).toBe "/(^rb)/"

      it 'creates "extension" regexp for input containing, but not starting, with a carat (^)', ->
        matcher = new Matcher 'r^b'
        expect(matcher._regexp.toString()).toBe '/(\\.r\\^b$)/'

      it 'creates "extension" regexp for input ending, but not starting, with a carat (^)', ->
        matcher = new Matcher 'r^'
        expect(matcher._regexp.toString()).toBe '/(\\.r\\^$)/'

    describe 'with dollar ($)', ->
      it 'creates regexp for input ending with a dollar ($)', ->
        matcher = new Matcher 'rb$'
        expect(matcher._regexp.toString()).toBe "/(rb$)/"

      it 'creates "extension" regexp for input containing, but not ending, with a dollar ($)', ->
        matcher = new Matcher 'r$b'
        expect(matcher._regexp.toString()).toBe '/(\\.r\\$b$)/'

      it 'creates "extension" regexp for input starting, but not ending, with a dollar ($)', ->
        matcher = new Matcher '$b'
        expect(matcher._regexp.toString()).toBe '/(\\.\\$b$)/'

    describe 'with unescaped dot (.)', ->
      it 'creates regexp for input starting with a dot (.)', ->
        matcher = new Matcher '.rb'
        expect(matcher._regexp.toString()).toBe "/(.rb)/"

      it 'creates regexp for input containing, but neither starting nor ending, with a dot (.)', ->
        matcher = new Matcher 'r.b'
        expect(matcher._regexp.toString()).toBe '/(r.b)/'

      it 'creates regexp for input ending with a dot (.)', ->
        matcher = new Matcher 'rb.'
        expect(matcher._regexp.toString()).toBe "/(rb.)/"

    describe 'with escaped dot (.)', ->
      it 'creates regexp for input starting with an escaped dot (.)', ->
        matcher = new Matcher '\\.rb'
        expect(matcher._regexp.toString()).toBe "/(\\.rb)/"

      it 'creates regexp for input containing, but neither starting nor ending, with an escaped dot (.)', ->
        matcher = new Matcher 'r\\.b'
        expect(matcher._regexp.toString()).toBe '/(r\\.b)/'

      it 'creates regexp for input ending with an escaped dot (.)', ->
        matcher = new Matcher 'rb\\.'
        expect(matcher._regexp.toString()).toBe "/(rb\\.)/"

    describe 'with pipe (|)', ->
      it 'creates regexp for input containing, but neither starting nor ending, with a pipe (|)', ->
        matcher = new Matcher 'r|b'
        expect(matcher._regexp.toString()).toBe '/(r|b)/'
