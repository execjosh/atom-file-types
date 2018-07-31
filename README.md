# file-types package

[![Installs!](https://img.shields.io/apm/dm/file-types.svg)](https://atom.io/packages/file-types)
[![Version!](https://img.shields.io/apm/v/file-types.svg)](https://atom.io/packages/file-types)
[![License](https://img.shields.io/apm/l/file-types.svg)](https://github.com/execjosh/atom-file-types/blob/master/LICENSE.md)

Specify additional file types for languages.

_Note:_ A subset of this functionality is now available directly in Atom--see [Customizing Language Recognition](http://flight-manual.atom.io/using-atom/sections/basic-customization/#customizing-language-recognition) in the Flight Manual.

# Matchers

To map a filetype to a different language, use the `file-types` option in your `config.json` (via the `Atom -> Config...` menu). Specify a pattern to match for the key (in bash-like glob format) and the new scope name for the value.

For example, the `.hbs` extension defaults to the `handlebars` grammar. To override this to the `text.html.htmlbars` grammar (provided by the separately installable `html-htmlbars`), add the following rule to your `config.cson`:

```cson
"*":  # Be sure to put "file-types" under the "*" key
  "file-types":
    "*.hbs": "text.html.htmlbars"
```

Use the double-star-and-slash notation (`**` and `/`) to match against the whole path.

```cson
"*":
  "file-types":
    "**/app/tmpl/*.hbs": "text.html.htmlbars"
    "**/text_files/*": "text.plain"
```

## Precedence

The longest glob is given precedence.

For example, with the following settings, all three globs end in `.liquid`.

```cson
"*":
  "file-types":
    "*.css.liquid": "source.css"
    "*.liquid": "text.html.basic"
    "*.scss.liquid": "source.css.scss"
```

Both `*.liquid` and `*.css.liquid` would match a file named `super_awesome_file.css.liquid`; however, since `*.css.liquid` is longest, it wins and the `source.css` scope name would be used.

This is usually not a problem unless multiple globs of equal length match the filename. When that happens, a warning is displayed and the scope name associated with the "alphabetically last" glob is used.

Consider the following settings:

```cson
"*":
  "file-types":
    "*_spec.rb": "source.ruby.rspec"
    "*_sp?c.rb": "text.plain"
```

Both of these would match a file named `super_controller_spec.rb`; however, `*_spec.rb` would win because when sorted alphabetically, it comes last (i.e., `"*_sp?c.rb" < "*_spec.rb"`).

# Scope Names

The scope name for a grammar can be found in the settings for the corresponding language package. For example, the scope name for CoffeeScript's grammar (as provided by the [language-coffee-script package](https://github.com/atom/language-coffee-script)) is `source.coffee`.

To get a list of all scope names registered in your Atom instance, open the Developer Tools Console and execute the following:

```javascript
console.log(atom.grammars.getGrammars().map(g => g.scopeName).sort().join('\n'))
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
