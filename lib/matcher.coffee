# See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions
escapeRegExp = (string) ->
  # $& means the whole matched string
  string.replace /[.*+?^${}()|[\]\\]/g, '\\$&'

module.exports =
class Matcher
  constructor: (matcher, scopeName, opts = {}) ->
    regexpOpts = ''

    if opts.caseSensitive
      regexpOpts += 'i'

    matcher = if matcher? then "#{matcher}" else ''

    if matcher.length <= 0
      # TODO: Throw error?
      @_regexp = null
    else if /(^\^)|([.|])|(\$$)/.test matcher
      @_regexp = new RegExp "(#{matcher})", regexpOpts
    else
      # Otherwise, we assume it is an extension matcher
      @_regexp = new RegExp "(\\.#{escapeRegExp(matcher)}$)", regexpOpts

  match: (string) ->
    RegExp.lastMatch if @_regexp?.test(string)

  toString: ->
    if @_regexp? then @_regexp.toString() else 'undefined'
