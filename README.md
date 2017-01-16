# file-types package

[![Installs!](https://img.shields.io/apm/dm/file-types.svg)](https://atom.io/packages/file-types)
[![Version!](https://img.shields.io/apm/v/file-types.svg)](https://atom.io/packages/file-types)
[![License](https://img.shields.io/apm/l/file-types.svg)](https://github.com/execjosh/atom-file-types/blob/master/LICENSE.md)

Specify additional file types for languages.

_Note:_ A subset of this functionality is now available directly in Atom--see [Customizing Language Recognition](http://flight-manual.atom.io/using-atom/sections/basic-customization/#_customizing_language_recognition) in the Flight Manual.

## Extension Matchers

To map a filetype to a new language, use the `file-types` option. Specify the extension (without a dot) as a key, and the new default extension as the value.

For example, the `.hbs` extension defaults to the `handlebars` grammar. To change it to default to `html-htmlbars` (installed separately), open your `config.cson` (via the `Atom -> Config...` menu) and add the following rule:

```cson
"*": # make sure to put all "file-types" options under the "*" key
  "file-types":
    "hbs": "text.html.htmlbars"
```

An extension matcher will be converted into a RegExp matcher. The example above is equivalent to the following:

```coffee
"*":
  "file-types":
    "\\.hbs$": "text.html.htmlbars"
```

To see all available grammars registered in your Atom instance, open the Developer Tools Console and execute the following:

```javascript
console.log(Object.keys(atom.grammars.grammarsByScopeName).sort().join("\n"))
```

## RegExp Matchers

You can match with regular expressions, too. Most JavaScript regular expressions should work; but, the system looks for a dot (`.`), a pipe (`|`), a caret (`^`) at the start, or a dollar (`$`) at the end to identify RegExp matchers.

The RegExp is currently matched against the base name of the file, as opposed to the entire path.

For example, you can associate `/.*_steps\.rb$/` with `source.cucumber.steps` in your `config.cson` as follows:

```cson
"*": # make sure to put all "file-types" options under the "*" key
  "file-types":
    "_steps\\.rb$": "source.cucumber.steps"
```

The longest match is given precedence. If there are multiple matches of equal length, then a warning is displayed and the "last" (alphabetically) match is used.

# Scope Names

The scope name for a grammar can be found in the settings for the corresponding language package. For example, the scope name for CoffeeScript's grammar (as provided by the [language-coffee-script package](https://github.com/atom/language-coffee-script)) is `source.coffee`.

To get a list of all scope names registered in your Atom instance, open the Developer Tools Console and execute the following:

```javascript
Object.keys(atom.grammars.grammarsByScopeName).sort().join('\n')
```

Here is a list of the scope names available by default in Atom v1.8.0:

- source.c
- source.cake
- source.clojure
- source.coffee
- source.coffee.jsx
- source.cpp
- source.cs
- source.css
- source.css.less
- source.css.scss
- source.csx
- source.gfm
- source.git-config
- source.go
- source.gotemplate
- source.java
- source.java-properties
- source.js
- source.js.jsx
- source.js.rails source.js.jquery
- source.js.regexp
- source.js.regexp.replacement
- source.json
- source.litcoffee
- source.makefile
- source.nant-build
- source.objc
- source.objcpp
- source.perl
- source.perl6
- source.plist
- source.python
- source.regexp.python
- source.ruby
- source.ruby.rails
- source.ruby.rails.rjs
- source.sass
- source.shell
- source.sql
- source.sql.mustache
- source.sql.ruby
- source.strings
- source.toml
- source.yaml
- text.git-commit
- text.git-rebase
- text.html.basic
- text.html.erb
- text.html.gohtml
- text.html.jsp
- text.html.mustache
- text.html.php
- text.html.ruby
- text.hyperlink
- text.junit-test-report
- text.plain
- text.plain.null-grammar
- text.python.console
- text.python.traceback
- text.shell-session
- text.todo
- text.xml
- text.xml.plist
- text.xml.xsl

# Caveats

You probably don't want to assign the same file type to multiple languages...
