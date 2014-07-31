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

# Languages

You specify the scope name of the grammar. A grammar's scope name can be found in the settings for the package providing that grammar.

For example, the scope name for CoffeeScript's grammar (provided by Language Coffee Script package) is `source.coffee`.

![Screenshot of Language Coffee Script package](https://cloud.githubusercontent.com/assets/189989/3765082/565e67c8-18b8-11e4-8188-776ee02fd8d7.png)

Unfortunately, the a list of all *scope name*s is environment-based (the user can install new language packages). Open up the Developer Tools Console and execute the following to get a list of all *scope name*s registered in your Atom instance:

```javascript
Object.keys(atom.syntax.grammarsByScopeName).sort().join('\n')
```

Here's an example from the author:

* source.c
* source.c++
* source.coffee
* source.css
* source.css.less
* source.css.scss
* source.gfm
* source.git-config
* source.go
* source.java
* source.java-properties
* source.js
* source.js.rails source.js.jquery
* source.js.regexp
* source.json
* source.litcoffee
* source.makefile
* source.objc
* source.objc++
* source.perl
* source.plist
* source.python
* source.regexp.python
* source.ruby
* source.ruby.rails
* source.ruby.rails.rjs
* source.sass
* source.shell
* source.sql
* source.sql.ruby
* source.strings
* source.toml
* source.yaml
* text.git-commit
* text.git-rebase
* text.html.basic
* text.html.erb
* text.html.jsp
* text.html.php
* text.html.ruby
* text.hyperlink
* text.junit-test-report
* text.plain
* text.plain.null-grammar
* text.todo
* text.xml
* text.xml.plist
* text.xml.xsl


# Caveats

You probably don't want to assign the same file type to multiple languages...
