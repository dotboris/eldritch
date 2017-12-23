Eldritch
========

_The dark arts of concurrent programming._

A DSL that adds parallel programming constructs to make your life a little easier.

Code quality
------------

[![Build Status](http://travis-ci.org/dotboris/eldritch.svg?branch=master)](http://travis-ci.org/dotboris/eldritch)
[![Coverage Status](http://coveralls.io/repos/dotboris/eldritch/badge.png)](http://coveralls.io/r/dotboris/eldritch)
[![Code Climate](http://codeclimate.com/github/dotboris/eldritch.png)](http://codeclimate.com/github/dotboris/eldritch)

Usage
-----

1.  Install it `gem install eldritch`
1.  Require it `require 'eldritch'`
1.  Use it (see features below)

By default eldritch will inject the DSL into the global scope. If you don't want this, you can require `eldritch/safe`
instead of `eldritch`.

```ruby
require 'eldricth/safe'

class MyClass
  include Eldritch::DSL
  extend Eldritch::DSL

  # The DSL is available in this class
end
```

Features
--------

### async methods

Async methods run concurrently when called. The caller is returned control right away and the method runs in the
background.

```ruby
require 'eldritch'

# define an async method
async def send_email(email)
  # ...
end

send_email(some_email) # runs in the background
```

#### ruby 1.9.3 and 2.0.0

For all versions of ruby before 2.1.0, you need to define async methods like so:

```ruby
def foo
  # stuff
end
async :foo
```

Since ruby 2.1.0, def returns the name of the method defined as a symbol. This allows for the cleaner `async def foo`
syntax.

### async blocks

Async blocks are run concurrently.

```ruby
require 'eldritch'

async do
  # runs in the background
end
```

### tasks

Async blocks and async methods both return tasks. These can be used to interact with the async block/method.

```ruby
require 'eldritch'

task = async do
  # calculate something that will take a long time
end

# we need to result of the task
res = 2 + task.value # waits for the task to finish
```

### together blocks

Together blocks are used to control all async blocks and methods within them as a group. Before exiting, together blocks
wait for all their async calls to be done before returning.

```ruby
require 'eldritch'

together do
  1000.times do
    async do
      # do some work
    end
  end
end
# all 1000 tasks are done
```

These blocks can also take an argument. This argument is a group that can be used to control the async calls in the
block. See the documentation for Eldritch::Group for more information.

```ruby
require 'eldritch'

together do |group|
  5.times do
    async do
      # do something
      group.interrupt if some_condition  # stops all other tasks
    end
  end
end
```

A note on GIL
-------------

MRI has this nasty little feature called a _GIL_ or _Global Interpreter Lock_. This lock makes it so that only one
thread can run at a time. Let's say that you have 4 cores, running threaded code on MRI will only make use of 1 core.
Sometimes, you might not gain a speed boost if you make code parallel. This could the case even if theory says otherwise.

Not all ruby implementations use a _GIL_. For example, jRuby does not use a _GIL_.

If your ruby implementation has a _GIL_, you will probably see a speed boost if your code does a lot of IO or anything
that's blocking. In that case running on a single core is not that much of a hindrance, because most of the threads will
be blocked and your code should run more often.

Running examples
----------------

If you installed eldritch with gem, you can just run the examples directly. If you are running them against a clone of
this repository you need to add `lib/` to the include path.

```sh
ruby -Ilib examples/the_example.rb
```

Be aware that if you are running ruby < 2.1.0, some the examples may not work. All the examples that define async
methods with `async def something; end` will not work. This is because, since ruby 2.1.0, def returns the name of the
method defined as a symbol.
