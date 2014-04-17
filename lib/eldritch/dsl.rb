module Eldritch
  module DSL
    def async(method=nil, &block)
      if block
        async_block(&block)
      else
        async_method(method)
      end
    end

    def sync(task)
      task.value
    end

    def together
      t = Together.new
      Thread.current.together = t
      yield t
      t.wait_all
      Thread.current.together = nil
    end

    private

    def async_block(&block)
      task = Task.new {|t| t.value = block.call }
      Thread.current.together << task
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