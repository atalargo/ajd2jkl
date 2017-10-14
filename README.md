# Ajd2jkl

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ajd2jkl`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ajd2jkl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ajd2jkl

## Usage
```apj2kl --help```

Display:

```bash
 NAME:

   ApiJSDoc 2 Jekyll

 DESCRIPTION:

   Command to parse file code using apidocjs comment to generate API docs in Jekyll format

 COMMANDS:

   genlist List all available generators and exit
   help    Display global or [command] help documentation
   parse   Parse the sources in given directories and generate the doc
   serve  Parse the sources in given directories and generate the doc

 GLOBAL OPTIONS:

   --verbose


   -h, --help
       Display help documentation

   -v, --version
       Display version information

   -t, --trace
       Display backtrace when an error occurs
```

Sub command `parse` (it's the default command launched):
```ajd2jkl parse --help```

Display:

```bash

NAME:

  parse

SYNOPSIS:

  ajd2jkl parse [options] [src_dir ..]

DESCRIPTION:

  Parse the sources in given directories and generate the doc

OPTIONS:

  --dry-run
      Only parse don't generate the doc

  --debug
      Debug mode

  --output STRING
      Output directory default is './doc'

  --imgs STRING
      Images directory to import

  --config STRING
      Configuration file. Json or YAML format

  --generator STRING
      Type of generate to use: Jekyll (default), swagger, etc. See command genlist for list of available generators
```

Sub command `genlist`
```ajd2jkl genlist --help```

```bash
  NAME:

    genlist

  SYNOPSIS:

    ajd2jkl genlist

  DESCRIPTION:

    List all available generators and exit
```

Current output of `genlist`
```ajd2jkl genlist```

```bash
Available generators are:

- Jekyll: Use Jekyll to generate a static documentation website, option: jekyll

Default generator is Jekyll
```

Sub command `serve`
```ajd2jkl serve --help```

```bash
  NAME:

    serve

  SYNOPSIS:

    ajd2jkl serve [options]

  DESCRIPTION:

    Parse the sources in given directories and generate the doc

  OPTIONS:

    --output STRING
        Output directory default is './doc'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Todo

- unit tests
- manage all language (not only php)
- configurable settings in file
- themable output

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ajd2jkl.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
