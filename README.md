# logbook-ruby

`logbook-ruby` is a Ruby library providing a parser for Logbook files.

## On Logbooks

Logbooks are plain text files used to capture thoughts and activities as they
occur throughout the day without interrupting flow as much as possible.

The rather minimalistic syntax is optimized for readability and quick editing
without the need for anything fancier than a good text editor.

To find out more about logbooks and the logbook file format, check out the
documentation of [the vim plugin](https://github.com/logbooksh/vim-logbook).

## Installation

`logbook-ruby` was tested on Ruby 2.4.

Add this line to your application's Gemfile:

```ruby
gem 'logbook-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logbook-ruby

## Usage

```ruby
require 'logbook-ruby`

file_path = "my-logbook.logbook"
file_contents = File.read(file_path)
logbook_page = Logbook::Builder.build(file_contents)

p logbook_page.properties
p logbook_page.entries
p logbook_page.tasks
```

## License

`logbook-ruby` is under the Apache License 2.0. See [`LICENSE`](LICENSE) for more
information.
