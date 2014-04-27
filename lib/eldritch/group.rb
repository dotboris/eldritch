require 'thread'

module Eldritch
  # Represents a group of {Task tasks} or {DSL#async async calls/block}.
  # It is used to act upon all the tasks in the group.
  class Group
    def initialize
      @tasks = []
      @mutex = Mutex.new
      @accept = true
    end

    # @return [Array<Task>] the other async calls/blocks in the group
    def others
      @tasks - [Thread.current.task]
    end

    def <<(task)
      accept = nil

      @mutex.synchronize do
        # copy accept for the task.start condition
        accept = @accept
        @tasks << task if accept
      end

      task.start if accept
    end

    # Yields the block in mutual exclusion with all the async calls/tasks
    #
    # @yield
    def synchronize(&block)
      @mutex.synchronize { block.call }
    end

    def wait_all
      @tasks.each {|t| t.wait}
    end

    # Aborts the other async calls/blocks in the group
    #
    # *Warning*: This call will directly kill underlying threads. This isn't very safe.
    #
    # @see Task#abort
    def abort
      @mutex.synchronize do
        @accept = false
        others.each &:abort
      end
    end

    # Interrupts the other async calls/blocks in the group
    #
    # Interruptions are done using exceptions that can be caught by the async calls/blocks to perform cleanup.
    #
    # @see Task#interrupt
    def interrupt
      @mutex.synchronize do
        @accept = false
        others.each &:interrupt
      end
    end
  end

  class NilGroup
    def <<(task)
      task.start
    end

    def nil?
      true
    end
  end
end