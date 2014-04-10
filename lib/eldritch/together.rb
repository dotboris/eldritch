module Eldritch
  class Together
    def initialize
      @tasks = []
    end

    def <<(task)
      @tasks << task
    end

    def wait_all
      @tasks.each {|t| t.wait}
    end
  end
end