module Eldritch
  module DSL
    def async(method)
      new_method = async_method_name(method)
      alias_method new_method, method
      define_method method do |*args|
        Thread.new { send new_method, *args }
      end
    end

    private

    def async_method_name(method)
      "__async_#{method}".to_sym
    end
  end
end