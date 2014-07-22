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

# Caveats

You probably don't want to assign the same file type to multiple languages...
