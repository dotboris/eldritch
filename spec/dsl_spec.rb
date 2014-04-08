require 'spec_helper'
require 'eldritch/dsl'

describe Eldritch::DSL do
  describe '#async(method)' do
    it 'should create a __async method' do
      klass = Class.new do
        extend Eldritch::DSL
        async def foo; end
      end

      expect(klass.new).to respond_to(:__async_foo)
    end
  end
end