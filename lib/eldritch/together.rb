require 'thread'

module Eldritch
  class Together
    using Eldritch::Refinements

    def initialize
      @tasks = []
      @mutex = Mutex.new
      @accept = true
    end

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

    def synchronize(&block)
      @mutex.synchronize { block.call }
    end

    def wait_all
      @mutex.synchronize do
        @tasks.each {|t| t.wait}
      end
    end

    def abort
      @mutex.synchronize do
        @accept = false
        others.each &:abort
      end
    end

    def interrupt
      @mutex.synchronize do
        @accept = false
        others.each &:interrupt
      end
    end
  end

  class NilTogether
    def <<(task)
      task.start
    end

    def nil?
      true
    end
  end
end