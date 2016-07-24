{extname} = require 'path'
Matcher = require './matcher'

module.exports =
class ScopeNameProvider
  constructor: ->
    @_matchers = {}
    @_scopeNames = {}

  registerMatcher: (pattern, scopeName, opts = {}) ->
    @_matchers[scopeName] ?= []
    matcher = new Matcher pattern, scopeName, opts
    @_matchers[scopeName].push matcher
    @_scopeNames[scopeName] = scopeName
    return  # void

  getScopeName: (filename) ->
    # scopeName : pattern
    matches = @_matchFilename filename
    keys = Object.keys matches
    len = keys.length

    # If no scopes matched, return nothing
    return if len <= 0

    # If only one scope matched, return it
    return keys[0] if len is 1

    # If multiple scopes found...

    # Sort keys by match alphabetically
    keys.sort (a, b) ->
      a = matches[a]
      b = matches[b]
      if a < b
        -1
      else if a > b
        1
      else
        0

    # Choose last scopeName
    scopeName = keys[len - 1]

    # Show a notification
    atom.notifications.addWarning '[file-types] Multiple Matches',
      detail: """
        Assuming '#{scopeName}' for file '#{filename}'.

        #{("- '#{p}': '#{sn}'" for sn, p of matches).join '\n'}
        """
      dismissable: true

    return scopeName

  getScopeNames: ->
    Object.keys @_scopeNames

  #
  # private
  #

  _matchFilename: (filename) ->
    longestLength = 0
    longestMatches = {}

    for scopeName, matchers of @_matchers
      # Start with previously longest length found and no match
      longestLengthForScope = longestLength
      longestMatchForScope = null

      for matcher in matchers
        continue unless matcher.match(filename)

        match = matcher.toString()
        len = match.length

        # Just skip if less-than longest length for scope
        continue if len < longestLengthForScope

        # Save match if longest (or equal-to longest) for scope
        longestLengthForScope = len
        longestMatchForScope = match

      # Skip this scope if no matches found
      continue unless longestMatchForScope?

      # Reset longest matches if longest
      if longestLengthForScope > longestLength
        longestMatches = {}

      # Save the longest match info
      longestLength = longestLengthForScope
      longestMatches[scopeName] = longestMatchForScope

    longestMatches
