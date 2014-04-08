module Eldritch
  module DSL
    def async(*args, &block)
      if args.size == 0
        async_block(&block)
      else
        async_method(args.first)
      end
    end

    def sync(task)
      task.value
    end

    private

    def async_block(&block)
      task = Task.new &block
      task.start
      task
    end

    def async_method(method)
      new_method = async_method_name(method)
      target = self.kind_of?(Module) ? self : self.class

      target.send :alias_method, new_method, method
      target.send :define_method, method do |*args|
        async_block {|t| t.value = send(new_method, *args) }
      end
    end

    def async_method_name(method)
      "__async_#{method}".to_sym
    end
  end
end