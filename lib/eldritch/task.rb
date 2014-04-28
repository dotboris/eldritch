module Eldritch
  # Runs a block in parallel and allows for interaction with said block
  class Task
    # @return [Thread] underlying ruby thread
    attr_reader :thread

    # Creates a new Task instance
    #
    # _Note_: this method does not yield the block directly this is done by {#start}
    #
    # @yield [Task] the task itself
    def initialize(&block)
      @block = block
    end

    # Starts the task
    #
    # This will yield the task to the block passed in the constructor.
    #
    #   task = Eldritch::Task.new do |task|
    #     # do something
    #   end
    #   task.start  # calls the block in parallel
    def start
      @thread = Thread.new &@block
      @thread.eldritch_task = self
    end

    # Waits for the task to complete
    def wait
      @thread.join
      unset_thread_task
    end

    # The return value of the task
    #
    # If the task is still running, it will block until it is done and then fetch the return value.
    #
    # @return whatever the block returns
    def value
      val = @thread.value
      unset_thread_task
      val
    end

    # Forces the task to end
    #
    # This kills the underlying thread. This is a dangerous call.
    def abort
      @thread.kill
      unset_thread_task
    end

    # Interrupts the task
    #
    # This is done by raising an {InterruptedError} in the task block.
    # This can be caught to perform cleanup before exiting.
    # Tasks started with {DSL#async} will automatically handle the exception and stop cleanly.
    # You can still handle the exception yourself.
    def interrupt
      @thread.raise InterruptedError.new
      unset_thread_task
    end

    private

    def unset_thread_task
      @thread.eldritch_task = nil
    end
  end
end