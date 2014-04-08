module Eldritch
  module DSL
    def async(method)
      new_method = async_method_name(method)
      target = self.kind_of?(Module) ? self : self.class

      target.send :alias_method, new_method, method
      target.send :define_method, method do |*args|
        Thread.new { send new_method, *args }
      end
    end

    private

    def async_method_name(method)
      "__async_#{method}".to_sym
    end
  end
end