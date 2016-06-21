# file-types package

Specify additional file types for languages.

Note: A subset of this functionality is now available directly in Atom - see [Customizing Language Recognition](http://flight-manual.atom.io/using-atom/sections/basic-customization/#_customizing_language_recognition) in the Flight Manual.

## Extension Matchers

To map a filetype to a new language, use the `file-types` option. Specify the extension
(without a dot) as a key, and the new default extension as the value.

For example, the `.hbs` extension defaults to the `handlebars` grammer. To change it to
default to `html-htmlbars` (installed separately), open your `config.cson` (via the `Atom
-> Config...` menu) and add the following rule:

```cson
"*": # make sure to put all 'file-types' options under the "*" key
  'file-types':
    'hbs': 'text.html.htmlbars'
```

To see all available grammers registered in your Atom instance, open the
Developer Tools Console and execute the following:

```javascript
console.log(Object.keys(atom.grammars.grammarsByScopeName).sort().join("\n"))
```

## RegExp Matchers

You can match with regular expressions, too.  Most JavaScript regular
expressions should work; but, the system looks for a dot (`.`), a caret (`^`) at
the start, or a dollar (`$`) to identify RegExp matchers.

For example, you can associate `/.*_steps\.rb$/` with `source.cucumber.steps` in
your `config.cson` as follows:

```cson
'file-types':
  '_steps\\.rb$': 'source.cucumber.steps'
```

*NOTE:* Extension Matchers take priority over RegExp Matchers.

# Scope Names

The scope name for a grammar can be found in the settings for the corresponding
language package.  For example, the scope name for CoffeeScript's grammar (as
provided by the Language Coffee Script package) is `source.coffee`.

To get a list of all scope names registered in your Atom instance, open the
Developer Tools Console and execute the following:

```javascript
Object.keys(atom.grammars.grammarsByScopeName).sort().join('\n')
```

Here is a list of the scope names available by default in Atom v1.8.0:

 *  source.c
 *  source.cake
 *  source.clojure
 *  source.coffee
 *  source.coffee.jsx
 *  source.cpp
 *  source.cs
 *  source.css
 *  source.css.less
 *  source.css.scss
 *  source.csx
 *  source.gfm
 *  source.git-config
 *  source.go
 *  source.gotemplate
 *  source.java
 *  source.java-properties
 *  source.js
 *  source.js.jsx
 *  source.js.rails source.js.jquery
 *  source.js.regexp
 *  source.js.regexp.replacement
 *  source.json
 *  source.litcoffee
 *  source.makefile
 *  source.nant-build
 *  source.objc
 *  source.objcpp
 *  source.perl
 *  source.perl6
 *  source.plist
 *  source.python
 *  source.regexp.python
 *  source.ruby
 *  source.ruby.rails
 *  source.ruby.rails.rjs
 *  source.sass
 *  source.shell
 *  source.sql
 *  source.sql.mustache
 *  source.sql.ruby
 *  source.strings
 *  source.toml
 *  source.yaml
 *  text.git-commit
 *  text.git-rebase
 *  text.html.basic
 *  text.html.erb
 *  text.html.gohtml
 *  text.html.jsp
 *  text.html.mustache
 *  text.html.php
 *  text.html.ruby
 *  text.hyperlink
 *  text.junit-test-report
 *  text.plain
 *  text.plain.null-grammar
 *  text.python.console
 *  text.python.traceback
 *  text.shell-session
 *  text.todo
 *  text.xml
 *  text.xml.plist
 *  text.xml.xsl

# Caveats

You probably don't want to assign the same file type to multiple languages...
