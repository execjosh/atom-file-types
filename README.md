# file-types package

Specify additional file types for languages.

## Extension Matchers

Drop the dot before the extension to use extension matchers.

For example, you can associate `.ex_em_el` with `text.xml` in your `config.cson`
as follows:

```cson
'file-types':
  'ex_em_el': 'text.xml'
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

Here is a list of the scope names available by default in Atom v0.207.0:

 *  source.c
 *  source.clojure
 *  source.coffee
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
 *  source.js.rails source.js.jquery
 *  source.js.regexp
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
