# Power Types
[![Gem Version](https://badge.fury.io/rb/power-types.svg)](https://badge.fury.io/rb/power-types)
[![CircleCI](https://circleci.com/gh/platanus/local_resource.svg?style=shield)](https://app.circleci.com/pipelines/github/platanus/local_resource)
[![Coverage Status](https://coveralls.io/repos/github/platanus/power-types/badge.svg)](https://coveralls.io/github/platanus/power-types)

Rails pattern enforcing types used by the Platanus team.

## Introduction

In Rails projects, Platanus encourages to use classes beyond models and controllers to hold the app's logic.
These powerful types proposed are Services, Commands, Observers, Utils and Values.

For a deeper understanding about the usage of these patterns, feel welcome to read the [related post in Platanus Blog](https://blog.platan.us/services-commands-y-otros-poderosos-patrones-en-rails-27c2d3aa7c2e) (in spanish).

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

- [Power Types](#power-types)
  - [Introduction](#introduction)
  - [Installation](#installation)
  - [Power types](#power-types-1)
    - [Services](#services)
    - [Commands](#commands)
    - [Observers](#observers)
    - [Values](#values)
    - [Presenters](#presenters)
    - [Utils](#utils)
  - [Publishing](#publishing)
  - [Contributing](#contributing)
  - [Credits](#credits)
  - [License](#license)

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

Now, suppose you have defined the following model (with name and villain attributes) and observer:

```ruby
class Wizard < ActiveRecord::Base
  include PowerTypes::Observable
end
```

```ruby
class WizardObserver < PowerTypes::Observer
  after_create :kill_villain

  def kill_villain
    p "#{object.name} has killed #{object.villain}"
  end
end
```

Then, you can use it like this:

```ruby
Wizard.create!(name: "Gandalf", villain: "Sauron") #=> This action will trigger the method kill_villain defined in the WizardObserver's after_create callback.
```

> As you can guess, `object` holds the Wizard instance.

You can trigger multiple methods on the same callback. For example:

```ruby
class WizardObserver < PowerTypes::Observer
  after_create :kill_villain
  after_create :bury_villains_corpse

  def kill_villain
    p "#{object.name} has killed #{object.villain}"
  end

  def bury_villains_corpse
    p "#{object.name} has buried #{object.villain}'s corpse"
  end
end
```
Note: Triggering the event will preserve the order of the methods, so in the example `kill_villain` will be called before `bury_villains_corpse`.

Recently we added four new callbacks, `after_create_commit`, `after_update_commit`, `after_save_commit` and `after_destroy_commit`. With these callbacks we want to reproduce the `after_commit` transactional callback from Active Record. For this implementation we use the gem [After Commit Everywhere](https://github.com/Envek/after_commit_everywhere) to be able to use the `after_commit` callbacks outside the Active Record models.

### Values

This pattern doesn't have a generator.

Values are just simple Ruby classes, but watch out to keep them in the Values directory!

### Presenters

For generating presenters we use:

```
$ rails generate presenter users_show
```

This will create the `UsersShowPresenter` class, inheriting from a base class:

```ruby
class UsersShowPresenter < PowerTypes::PresenterBase
end
```

And its corresponding rspec file:

```ruby
require 'rails_helper'

describe UsersShowPresenter do
  pending "add some examples to (or delete) #{__FILE__}"
end
```

To initialize a presenter inside your controller action you should execute the `present_with` method with valid params:

```ruby
class UsersController < InheritedResources::Base
  def show
    presenter_params = { param1: 1, param2: 2 }
    @presenter = present_with(:users_show_presenter, presenter_params)
  end
end
```

You can access view helper methods through the `h` method:

```ruby
class UsersShowPresenter < PowerTypes::PresenterBase
  def platanus_link
    h.link_to "Hi Platanus!", "https://platan.us"
  end
end
```

You can access `presenter_params` inside the presenter as an `attr_reader`

```ruby
class UsersController < InheritedResources::Base
  def show
    presenter_params = { platanus_url: "https://platan.us" }
    @presenter = present_with(:users_show_presenter, presenter_params)
  end
end
```

```ruby
class UsersShowPresenter < PowerTypes::PresenterBase
  def platanus_link
    h.link_to "Hi Platanus!", platanus_url
  end
end
```

If the presenter param has a [decorator](https://github.com/drapergem/draper), the `attr_reader` will be decorated.

```ruby
class UsersController < InheritedResources::Base
  def show
    presenter_params = { user: user }
    @presenter = present_with(:users_show_presenter, presenter_params)
  end

  private

  def user
    @user ||= User.find!(params[:id])
  end
end
```

```ruby
class UserDecorator < Draper::Decorator
  delegate_all

  def cool_view_name
    "~º#{name}º~"
  end
end
```

```ruby
class UsersShowPresenter < PowerTypes::PresenterBase
  def platanus_link
    h.link_to "Hi #{user.cool_view_name}!", platanus_url
  end
end
```

In the view, you can use it like this:

```
<div><%= @presenter.platanus_link %></div>
```

### Utils

To generate a util we use:

```
$ bundle exec rails g util Numbers clean double
```

This will generate the `NumbersUtil` class in the `app/utils` directory, as follows:

```ruby
class NumbersUtil < PowerTypes::BaseUtil

  def self.clean
    # Method code goes here
  end

  def self.double
    # Method code goes here
  end

end
```

And it will generate the spec file as well, in the `spec/utils` directory:

```ruby
require 'rails_helper'

describe NumbersUtil do
  describe '#clean' do
    pending 'describe what the util method clean does here'
  end

  describe '#double' do
    pending 'describe what the util method double does here'
  end

end
```

Every util will inherit from the class `PowerTypes::BaseUtil` which raises an error when the initialize method is called. The purpose of this is to ensure that all the utils methods work as class methods. Thus, there is no need to create an instance of the util to use its methods. For instance, we could use the `NumbersUtil` as follows:

```ruby
NumbersUtil.clean('5.000') # -> 5000
NumbersUtil.double(100) # -> 200
```

## Publishing

On master/main branch...

1. Change `VERSION` in `lib/power-types/version.rb`.
2. Change `Unreleased` title to current version in `CHANGELOG.md`.
3. Run `bundle install`.
4. Commit new release. For example: `Releasing v0.1.0`.
5. Create tag. For example: `git tag v0.1.0`.
6. Push tag. For example: `git push origin v0.1.0`.

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
