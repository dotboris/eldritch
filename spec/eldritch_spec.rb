require 'spec_helper'

describe Eldritch do
  it 'should have a version number' do
    Eldritch::VERSION.should_not be_nil
  end

  describe '#inject_dsl' do
    it 'should include the dsl in Object' do
      expect(Object).to receive(:include).with(Eldritch::DSL)

      Eldritch.inject_dsl
    end

    it 'should allow classes to respond to dsl methods' do
      Eldritch.inject_dsl
      klass = Class.new

      expect(klass).to respond_to(:async)
      expect(klass).to respond_to(:sync)
      expect(klass).to respond_to(:together)
    end

    it 'should allow objects to respond to dsl methods' do
      Eldritch.inject_dsl
      obj = Object.new

      expect(obj).to respond_to(:async)
      expect(obj).to respond_to(:sync)
      expect(obj).to respond_to(:together)
    end
  end
end
