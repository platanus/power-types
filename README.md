# Power-Types
[![Gem Version](https://badge.fury.io/rb/power-types.svg)](https://badge.fury.io/rb/power-types) [![Build Status](https://travis-ci.org/platanus/power-types.svg?branch=master)](https://travis-ci.org/platanus/power-types) [![Coverage Status](https://coveralls.io/repos/github/platanus/power-types/badge.svg)](https://coveralls.io/github/platanus/power-types)

Rails pattern enforcing types used by the Platanus team

## Introduction

In Rails projects, Platanus encourages  to  use classes beyond models and controllers to hold the app's logic.
These powerful types proposed are Services, Commands, Utils and Values.

For a deeper understanding about the usage of these patterns, feel welcome to read the [related post in Platanus Blog](https://cb.platan.us/services-commands-y-otros-poderosos-patrones-en-rails) (in spanish).

The goal aimed with this gem is to go further, and not just apply this patterns over POROs (plain simple ruby classes).  The gem provides an special structure and syntax to create and run Services and Commands with ease.

It also creates the directory for each type, and provides generators.

## Usage

### Generators

For generating services we use:

    $ rails generate service MagicMakingService foo bar

This will create the MagicMakingService class, inheriting from a base service class:

    class MagicMakingService < PowerTypes::Service.new(:foo, bar: nil)

The arguments get available to be used in the service class as instance variables: `@foo` and `@bar`
Default values for arguments are optional, and can't be defined in the generator, but manually after.  In this case a `nil` value was given for `bar`.
This is a way to make the argument optional.  If no default value is assigned, the argument will be required, and an error raised if missing.

This generator will create its corresponding rspec file.



For generating commands:

    $ rails generate command MakeMagic foo bar

Which will generate the corresponding class, with the `perform` method.  This method must be implemented, and its called when the command is executed.

    class MakeMagic < PowerTypes::Command.new(:foo, bar: nil)

And in a similar way to services, the command's spec file is also created by this generator

### Instantiate and Run

We can create service objects like this

    magic_service = MagicMakingService.new(foo: my_foo, bar: "a bar")

And use any method the service provides

    magic_service.gandalfize(sauron)
    magic_service.harry_potterize(voldemort)

In the case of commands, we are not suposed to store or reuse the object.  You just want to run it and keep the result

    result = MakeMagic.for(foo: a_foo, bar:  "i'm bar")

### Values and Utils

This two types do not have generators.

Values are just simple Ruby classes, but watch out to keep them in the Values directory!

Utils should be defined as a module.  There you define the independent but related functions.  Use the extend self pattern to call them directly after the module name.
```ruby
module MagicTricks
extend self

    def dissappear(object)
        #blah blah
    end

    def shrink(children)
        #bleh bleeh
    end

    def shuffle(cards)
        #blaah
    end
```
Example of calling a Util function:

    MagicTricks.dissapear(rabbit)


## Credits

Thank you [contributors](https://github.com/platanus/power-types/graphs/contributors)!

<img src="http://platan.us/gravatar_with_text.png" alt="Platanus" width="250"/>

Power-Types is maintained by [platanus](http://platan.us).

## License

Power-Types is © 2016 Platanus, S.p.A. It is free software and may be redistributed under the terms specified in the LICENSE file.
