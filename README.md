# sanji

![sanji](http://icons.iconarchive.com/icons/crountch/one-piece-character/256/Sanji-icon.png)

Customized Rails application generator.
Inspired by [suspenders](https://github.com/thoughtbot/suspenders) and [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gems.

## Installation

```
gem install sanji
```

## Basic usage

```
sanji app_name
```

## Local Recipe

```ruby
class Sanji::Locals::MyRecipe < Sanji::Recipe

  def confirm
    # return a string (boolean question) to make this recipe optional
  end

  def after_create
    # execute after app is created
  end

  def after_bundle
    # execute after bundle
  end

  def after_everything
    # execute after "after_bundle"
  end

end
```

## Local Setup

- `.bash_profile`
  ```
  export SANJI_HOME=/path/to/sanji/
  ```

- `/path/to/sanji/sanji.yml`
  ```ruby
  cookbook: cookbook_name
  recipes: /path/to/recipes

  cookbooks:
    cookbook_name:
    - recipe_name
    - other_recipe_name
    - another_recipe

    my_cookbook:
    - my_recipe
  ```

## Inclusions

- Gems
  - pg - PostgreSQL adapter.
  - seedbank - Organize seeds.
  - annotate - Model annotations.
  - figaro - Read environment variables.
  - haml-rails - View template engine.
  - draper - Decorator for views.
  - reform - Form objects.
  - virtus - Coercion for Form objects.
  - bootstrap-sass - Twitter Bootstrap CSS and Javascripts (optional).
  - normalize-rails - CSS Reset (if bootstrap is not selected).
  - paperclip - Attachments for models.
  - kaminari - Pagination.
  - thin - Development web server.
  - quiet_assets - Prevent asset logs.
