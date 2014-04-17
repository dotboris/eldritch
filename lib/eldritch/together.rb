module Eldritch
  class Together
    def initialize
      @tasks = []
    end

    def others
      @tasks - [Thread.current.task]
    end

    def <<(task)
      @tasks << task
      task.start
    end

    def wait_all
      @tasks.each {|t| t.wait}
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