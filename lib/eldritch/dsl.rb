module Eldritch
  module DSL
    def async(method)
      alias_method async_method_name(method), method
    end

    private

    def async_method_name(method)
      "__async_#{method}".to_sym
    end
  end
end