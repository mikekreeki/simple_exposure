# SimpleExposure

![Gem version](http://img.shields.io/gem/v/simple_exposure.svg) 
![Code Climate](http://img.shields.io/codeclimate/github/mikekreeki/simple_exposure.svg)

Simplify sharing state between Rails controllers and views and reduce noise in Rails controllers for those who are tired of writing the same code over and over again.

Based on the idea behind [view_accessor](https://github.com/invisiblefunnel/view_accessor) borrowing features I like from [decent_exposure](https://github.com/voxdolo/decent_exposure).

## Basic example

```ruby
# controllers/projects_controller.rb
class ProjectsController < ApplicationController
  expose(:projects) { Project.all }
end

# views/projects/index.html.slim
- projects.each do |project|
  p = project.title
```

## Installation

Add this line to your application's Gemfile:

    gem 'simple_exposure'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_exposure

## Usage

### Share controller's state to the views:

```ruby
# controllers/projects_controller.rb
class ProjectsController < ApplicationController
  expose :projects

  def index
    self.projects = Project.all
  end
end

# views/projects/index.html.slim
- projects.each do |project|
  p = project.title
```

### Provide default values

```ruby
class ProjectsController < ApplicationController
  expose(:projects) { Project.all }
end
```

### Remove common noise with extensions

Before:

```ruby
class ProjectsController < ApplicationController

  def index
    @projects = Project.page(params[:page])
  end

end
```

After:

```ruby
class ProjectsController < ApplicationController
  expose :projects, extend: :paginate

  def index
    self.projects = Project.all
  end
end
```

### Combine multiple extensions

```ruby
class ProjectsController < ApplicationController
  expose :projects, extend: %i(paginate decorate)

  def index
    self.projects = Project.all
  end
end
```

### Combine it all together for a greater good

Before:

```ruby
class ProjectsController < ApplicationController

  def index
    @projects = current_user.projects.ordered
    @completed_projects = @projects.completed.page(params[:page])
    @current_user = current_user.decorate
  end

end
```

After:

```ruby
class ProjectsController < ApplicationController
  expose :current_user, extend: :decorate

  expose :projects do
    current_user.projects.ordered
  end

  expose :completed_projects, extend: :paginate do
    projects.completed
  end
end
```

## Extensions

### Built-in extensions

Library provides two built-in extensions:

+ paginate (Kaminari)
+ decorate (Draper)

### Writing your own extensions

```ruby
module SimpleExposure
  module Extensions
    module MyExtension
      extend self

      def apply(value, controller)
        # Do something with the value here
      end
    end
  end
end

class ProjectsController < ApplicationController
  expose :projects, extend: :my_extension
end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
