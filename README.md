# sanji

Customized Rails application generator.
Inspired by [suspenders](https://github.com/thoughtbot/suspenders) and [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gems.

![sanji](http://icons.iconarchive.com/icons/crountch/one-piece-character/256/Sanji-icon.png)

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
