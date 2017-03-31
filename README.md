# Power Types
[![Gem Version](https://badge.fury.io/rb/power-types.svg)](https://badge.fury.io/rb/power-types) [![Build Status](https://travis-ci.org/platanus/power-types.svg?branch=master)](https://travis-ci.org/platanus/power-types) [![Coverage Status](https://coveralls.io/repos/github/platanus/power-types/badge.svg)](https://coveralls.io/github/platanus/power-types)

Rails pattern enforcing types used by the Platanus team.

## Introduction

In Rails projects, Platanus encourages to use classes beyond models and controllers to hold the app's logic.
These powerful types proposed are Services, Commands, Observers, Utils and Values.

For a deeper understanding about the usage of these patterns, feel welcome to read the [related post in Platanus Blog](https://blog.platan.us/services-commands-y-otros-poderosos-patrones-en-rails) (in spanish).

The goal aimed with this gem is to go further, and not just apply this patterns over POROs (plain simple ruby classes). The gem provides an special structure and syntax to create and run services, commands and more, with ease.

It also creates the directory for each type, and provides generators.

## Installation

Add to your Gemfile:

```ruby
gem "power-types"
```

```bash
bundle install
```

## Power types

- [Services](#services)
- [Commands](#commands)
- [Observers](#observers)
- [Values and Utils](#values-and-utils)

### Services

For generating services we use:

```
$ rails generate service MyService foo bar
```

This will create the MyService class, inheriting from a base service class:

```ruby
class MyService < PowerTypes::Service.new(:foo, :bar)
  # Service code goes here
end
```

And its corresponding rspec file:

```ruby
require 'rails_helper'

describe MyService do
  def build(*_args)
    described_class.new(*_args)
  end

  pending "describe what your service does here"
end
```

The arguments get available to be used in the service class as instance variables: `@foo` and `@bar`.
Default values for arguments are optional, and can't be defined in the generator, but manually after like this:

```ruby
class MyService < PowerTypes::Service.new(foo: "X", bar: nil)
  # Service code goes here
end
```

This is a way to make the argument optional. If no default value is assigned, the argument will be required, and an error raised if missing.

Now, suppose you have defined the following service:

```ruby
class MagicMakingService < PowerTypes::Service.new(wizard: "Harry Potter")
  def gandalfize(who)
    "#{@wizard} gandalfized #{who}"
  end

  def harrypotterize(who)
    "#{@wizard} harrypotterized #{who}"
  end
end
```

Then, you can use it like this:

```ruby
magic_service = MagicMakingService.new(wizard: "Gandalf")
magic_service.gandalfize("Sauron") #=> "Gandalf gandalfized Sauron"

magic_service = MagicMakingService.new
magic_service.harrypotterize("Voldemort") #=> "Harry Potter harrypotterize Voldemort"
```

### Commands

For generating commands we use:

```
$ rails generate command ExecuteSomeAction foo bar
```

This will create the ExecuteSomeAction class, inheriting from a base command class:

```ruby
class ExecuteSomeAction < PowerTypes::Command.new(:foo, :bar)
  def perform
    # Command code goes here
  end
end
```

And its corresponding rspec file:

```ruby
require 'rails_helper'

describe ExecuteSomeAction do
  def perform(*_args)
    described_class.for(*_args)
  end

  pending "describe what perform does here"
end
```

The arguments get available to be used in the command class as instance variables: `@foo` and `@bar`.
Default values for arguments are optional, and can't be defined in the generator, but manually after like this:

```ruby
class ExecuteSomeAction < PowerTypes::Command.new(foo: "X", bar: nil)
  def perform
    # Command code goes here
  end
end
```

This is a way to make the argument optional. If no default value is assigned, the argument will be required, and an error raised if missing.

Now, suppose you have defined the following command:

```ruby
class MakeMagicTrick < PowerTypes::Command.new(:wizard, receiver: "Sauron")
  def perform
    "#{@wizard} enchanted #{@receiver}"
  end
end
```

Then, you can use it like this:

```ruby
MakeMagicTrick.for(wizard: "Gandalf") #=> "Gandalf enchanted Sauron"
MakeMagicTrick.for(wizard: "Harry Potter", receiver: "Voldemor") #=> "Harry Portter enchanted Voldemor"
```

> In the case of commands, we are not supposed to store or reuse the object. You just want to run it and keep the result.

### Observers

For generating observers we use:

```
$ rails generate observer MyModel
```

This will create the MyModelObserver class, inheriting from a base observer class:

```ruby
class MyModelObserver < PowerTypes::Observer
  # after_save :run
  # before_create { puts "yes, you can provide a block to work with" }
  #
  # def run
  #   p object # object holds an MyModel instance.
  # end
end
```

It will also include the `PowerTypes::Observable` mixin in `MyModel` class:

```ruby
class MyModel < ActiveRecord::Base
  include PowerTypes::Observable
end
```

And the corresponding rspec file:

```ruby
require 'rails_helper'

describe MyModelObserver do
  pending "add some examples to (or delete) #{__FILE__}"
end
```

Now, suppose you have defined the following model (with name and villian attributes) and observer:

```ruby
class Wizard < ActiveRecord::Base
  include PowerTypes::Observable
end
```

```ruby
class WizardObserver < PowerTypes::Observer
  after_create :kill_villain

  def kill_villain
    p "#{object.name} have killed #{object.villian}"
  end
end
```

Then, you can use it like this:

```ruby
Wizard.create!(name: "Gandalf", villian: "Sauron") #=> This action will trigger the method kill_villian defined in the WizardObserver's after_create callback.
```

> As you can guess, `object` holds the Wizard instance.

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
end  
```

Example of calling a Util function:

```ruby
MagicTricks.dissapear(rabbit)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Thank you [contributors](https://github.com/platanus/power-types/graphs/contributors)!

<img src="http://platan.us/gravatar_with_text.png" alt="Platanus" width="250"/>

Power-Types is maintained by [platanus](http://platan.us).

## License

Power Types is © 2016 Platanus, S.p.A. It is free software and may be redistributed under the terms specified in the LICENSE file.
