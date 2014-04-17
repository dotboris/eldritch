require 'thread'

module Eldritch
  class Together
    def initialize
      @tasks = []
      @mutex = Mutex.new
    end

    def others
      @tasks - [Thread.current.task]
    end

    def <<(task)
      @mutex.synchronize do
        @tasks << task
      end

      task.start
    end

    def wait_all
      @mutex.synchronize do
        @tasks.each {|t| t.wait}
      end
    end

    def abort
      @mutex.synchronize do
        others.each &:abort
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