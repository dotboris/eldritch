module Eldritch
  class Task
    using Eldritch::Refinements

    attr_writer :value
    attr_reader :thread

    def initialize(&block)
      @block = block
    end

    def start
      @thread = Thread.new self, &@block
      @thread.task = self
    end

    def wait
      @thread.join
    end

    def value
      wait
      @value
    end

    def abort
      @thread.kill
    end

    def interrupt
      @thread.raise InterruptedError.new
    end
  end
end