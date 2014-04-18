require 'spec_helper'
require 'eldritch/refinements/thread'

using Eldritch::Refinements

describe Thread do
  let(:thread) { Thread.new {} }

  it 'should have together accessor' do
    # refinements don't work with #respond_to? and send, we have to check for errors
    expect{thread.group}.not_to raise_error
    expect{thread.group = nil}.not_to raise_error
  end

  it 'should have a task accessor' do
    # refinements don't work with #respond_to? and send, we have to check for errors
    expect{thread.task}.not_to raise_error
    expect{thread.task = nil}.not_to raise_error
  end

  describe '#together' do
    it 'should return the togther previously set' do
      together = double('together')
      thread.group = together
      expect(thread.group).to eql(together)
    end

    it 'should return a NilTogether when none are set' do
      expect(thread.group).to be_a Eldritch::NilGroup
    end
  end

  describe '#together?' do
    it 'should be false when together is nil' do
      thread.group = nil
      expect(thread.in_group?).to be_false
    end

    it 'should be false when together is a NilTogether' do
      thread.group = Eldritch::NilGroup.new
      expect(thread.in_group?).to be_false
    end

    it 'should be true when together is set' do
      thread.group = 2
      expect(thread.in_group?).to be_true
    end
  end
end