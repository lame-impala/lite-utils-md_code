# lite-utils-md_code
Extracts runnable code inside MD fences, 
tagged with an identifier, so you can `eval` 
them from your test suite. The main use case: 
keeping documentation examples honest by actually 
running them as specs.

## Writing the documentation
Write runnable code in the MD file and mark it
with a tag and a unique identifier. The
fenced block looks somewhat like this in raw MD:
````ruby test rspec_example
```ruby test rspec_example
expect(true).to be(true)
```
````

The info string after the opening triple-backtick follows a fixed
grammar: `<language> <tag> <key>`, space-separated.

- `language` – the language identifier used for syntax highlighting
(e.g. `ruby`). Not interpreted by this library.
- `tag` – groups snippets so they can be filtered together. Matches
the `tag:` keyword passed to `MdCode.instance`.
- `key` – an identifier for this specific snippet, used later
to reference it via `SPECS.snippet!(:key)`. Must be unique
in a tag.

So ` ```ruby test unique_identifier ` declares a Ruby snippet, tagged
`test`, retrievable under the key `unique_identifier`.

## Writing the tests
Load the snippets somewhere in your specs. The positional
argument is the path to the file containing code snippets,
optional `tag` keyword specifies the tag used to filter
them – defaults to `:test`. Another 
optional keyword is `dir`, which can be used to pass over 
`__dir__` from the caller's location.
```ruby test extract_snippets
SPECS = MdCode.instance('../../../README.md', dir: __dir__)
```

Configure RSpec so that it ensures all snippets have been consumed
```ruby test rspec_config
RSpec.configure do |config|
  config.add_setting :readme_spec, default: false
  
  config.define_derived_metadata(file_path: %r{spec/utils/md_code}) do |meta|
    config.readme_spec = true
  end
  
  config.after(:suite) do
    next unless config.readme_spec
    
    SPECS.ensure_consumed!
  end
end
```

You may need a more complex configuration depending on 
how you structure your specs; however, the setup shown 
above works even with complex readme specs spreading 
across multiple files.

Eval the snippets inside your specs – either as a part of the context
or inside your examples. Note the bang at the end of the method name – 
this method tracks usage of individual keys and raises if it was 
called twice with the same key. This makes it easier to avoid mistakes
where your test evals some key by mistake and omits another,
making sure your whole documentation is tested as intended.
```ruby test rspec_eval
it 'is true' do 
  eval(SPECS.snippet!(:rspec_example))
end
```

Obviously the bang variant is meant for snippets that run 
exactly once across the whole suite. When the snippet 
represents shared setup – like a memoized helper body –
it must be allowed to evaluate repeatedly. In such 
case use `SPECS.snippet` without the bang. It still tracks 
usage but doesn't raise when the key is accessed multiple times.

**A note on `eval`**: This library works by evaluating snippet contents 
as Ruby source. That's inherent to the pattern – the whole point is 
to run your documentation's example code.

Snippets only ever come from files that already live in your own 
repository, and they're only evaluated inside your own test suite. 
You're not pulling snippets from user input, a network request, 
or any other untrusted source – just from docs you wrote yourself.

## License
This library is published under the MIT license
