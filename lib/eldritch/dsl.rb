module Eldritch
  # Provides DSL for:
  # - {#async async methods}
  # - {#async async blocks}
  # - {#together together blocks}
  # - {#sync sync keyword}
  module DSL
    # Creates an asynchronous method or starts an async block
    #
    # If a block is passed, this will be an async block.
    # Otherwise this method will create an async method.
    #
    # When an async block is called, it will yield the block in a new thread.
    #
    #   async do
    #     # will run in parallel
    #   end
    #   #=> <Task>
    #
    # When called, async methods behave exactly like async blocks.
    #
    #   async def foo
    #     # will run in parallel
    #   end
    #
    #   foo
    #   #=> <Task>
    # If you are using ruby < 2.1.0, you will need to define async methods like so:
    #
    #   def foo
    #     # will run in parallel
    #   end
    #   async :foo
    #
    # @param [Symbol] method the name of the async method.
    # @return [Task] a task representing the async method or block
    #   (only for async block and async method call)
    def async(method=nil, &block)
      if block
        async_block(&block)
      else
        async_method(method)
      end
    end

    # Allows async methods to be called like synchronous methods
    #
    #   sync send_email(42) # send_mail is async
    #
    # @param [Task] task a task returned by {#async}
    # @return whatever the method has returned
    def sync(task)
      task.value
    end

    # Creates a group of async call and blocks
    #
    # When async blocks and calls are inside a together block, they can act as a group.
    #
    # A together block waits for all the async call/blocks that were started within itself to stop before continuing.
    #
    #   together do
    #     5.times do
    #       async { sleep(1) }
    #     end
    #   end
    #   # waits for all 5 async blocks to complete
    #
    # A together block will also yield a {Group}. This can be used to interact with the other async calls/blocks.
    #
    #   together do |group|
    #     5.times do
    #       async do
    #         # stop everyone else
    #         group.interrupt if something?
    #       end
    #     end
    #   end
    #
    # @yield [Group] group of async blocks/calls
    # @see Group Group class
    def together
      old = Thread.current.eldritch_group

      group = Group.new
      Thread.current.eldritch_group = group

      yield group

      group.wait_all
      Thread.current.eldritch_group = old
    end

    private

    def async_block(&block)
      task = Task.new do |t|
        begin
          t.value = block.call
        rescue InterruptedError
        end
      end
      Thread.current.eldritch_group << task
      task
    end

    def async_method(method)
      new_method = async_method_name(method)
      target = self.kind_of?(Module) ? self : self.class

      target.send :alias_method, new_method, method
      target.send :define_method, method do |*args|
        async { send(new_method, *args) }
      end
    end

    def async_method_name(method)
      "__async_#{method}".to_sym
    end
  end
end