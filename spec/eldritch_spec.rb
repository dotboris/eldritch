require 'spec_helper'

describe Eldritch do
  it 'should have a version number' do
    Eldritch::VERSION.should_not be_nil
  end

  describe '#inject_dsl' do
    it 'should include the dsl' do
      klass = double('klass').as_null_object

      expect(klass).to receive(:include).with(Eldritch::DSL)

      Eldritch.inject_dsl(klass)
    end

    it 'should extend the dsl' do
      klass = double('klass').as_null_object

      expect(klass).to receive(:extend).with(Eldritch::DSL)

      Eldritch.inject_dsl(klass)
    end
  end
end
