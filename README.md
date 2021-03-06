# SimpleExposure

![Gem version](http://img.shields.io/gem/v/simple_exposure.svg)
![Code Climate](http://img.shields.io/codeclimate/github/mikekreeki/simple_exposure.svg)
![Travis CI](http://img.shields.io/travis/mikekreeki/simple_exposure.svg)
![Github Issues](http://img.shields.io/github/issues/mikekreeki/simple_exposure.svg)

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

Wait, there's  more!

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
  expose :projects, :project

  def index
    self.projects = Project.all
  end

  def show
    self.project = Project.find(1)
  end
end

# views/projects/index.html.slim
- projects.each do |project|
  p = project.title
```

Expose controller methods to the views:

```ruby
# controllers/projects_controller.rb
class ProjectsController < ApplicationController
  expose :project

  private

  def project
    @project ||= Project.find(1)
  end
end
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
  paginate :projects

  def index
    self.projects = Project.all
  end
end
```

Which is the same as:

```ruby
class ProjectsController < ApplicationController
  expose :projects, extend: :paginate

  def index
    self.projects = Project.all
  end
end
```

### Combine multiple extensions

Before:

```ruby
class ProjectsController < ApplicationController

  def index
    @projects = Project.page(params[:page]).decorate
  end
end
```

After:

```ruby
class ProjectsController < ApplicationController
  paginate :projects, extend: :decorate

  def index
    self.projects = Project.all
  end
end
```

Which is the same as:

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
  decorate :current_user

  expose :projects do
    current_user.projects.ordered
  end

  paginate(:completed_projects) { projects.completed }
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
  my_extension :projects
  # or
  expose :projects, extend: :my_extension
end
```

Note that extensions are applied at the time of `render`, not immediately when the value is assigned.

## Similar projects

+ [view_accessor](https://github.com/invisiblefunnel/view_accessor)
+ [obviews](https://github.com/elia/obviews)
+ [decent_exposure](https://github.com/voxdolo/decent_exposure)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
