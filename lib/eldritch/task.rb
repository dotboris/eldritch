module Eldritch
  class Task
    def initialize(&block)
      @block = block
    end

    def start
      @thread = Thread.new &@block
    end

    def wait
      @thread.join
    end
  end
end