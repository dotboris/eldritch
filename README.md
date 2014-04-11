Eldritch
========

_The dark arts of concurrent programming._

**This gem is in development and in no way shape or form production ready.**

A ruby gem that adds parallel programming constructs to make your life a little easier.

Code quality
------------

[![Build Status](http://travis-ci.org/beraboris/eldritch.svg?branch=master)](http://travis-ci.org/beraboris/eldritch)

[![Coverage Status](http://coveralls.io/repos/beraboris/eldritch/badge.png)](http://coveralls.io/r/beraboris/eldritch)

[![Code Climate](http://codeclimate.com/github/beraboris/eldritch.png)](http://codeclimate.com/github/beraboris/eldritch)

Features
--------

### async methods

Async methods run concurrently when called. The caller is returned controlled right away and the method runs in the
background.

```ruby
require 'eldritch'

# define an async method
async def send_email(email)
  # ...
end

# ...
send_email(some_email) # runs in the background
# ...
```

### async blocks

Async blocks are run concurrently.

```ruby
require 'eldritch'

# do some work
async do
  # some long running task ...
end
# continue working
```

### tasks

Async blocks and async methods both return tasks. These can be used to interact with the async block/method. As of now,
you can wait for the task to finish or you can get its return value.

```ruby
require 'eldritch'

task = async do
  # calculate something that will take a long time
end

# ...

# now we need to result of the task
res = 2 + task.value # waits for the task to finish
```

### together blocks

Together blocks are used to control all async blocks and methods within them as a group. Right now, the together block
waits for all async calls be de done before exiting.

```ruby
require 'eldritch'

together do
  1000.each do
    async do
      # do some work
    end
  end
end
# all 1000 tasks are done
```

Installation
------------

Add this line to your application's Gemfile:

    gem 'eldritch'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eldritch
