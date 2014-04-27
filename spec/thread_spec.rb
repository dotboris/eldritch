require 'spec_helper'
require 'eldritch/core_ext/thread'

describe Thread do
  let(:thread) { Thread.new {} }

  it 'should have group accessor' do
    # refinements don't work with #respond_to? and send, we have to check for errors
    expect{thread.group}.not_to raise_error
    expect{thread.group = nil}.not_to raise_error
  end

  it 'should have a task accessor' do
    # refinements don't work with #respond_to? and send, we have to check for errors
    expect{thread.task}.not_to raise_error
    expect{thread.task = nil}.not_to raise_error
  end

  describe '#group' do
    it 'should return the togther previously set' do
      group = double('group')
      thread.group = group
      expect(thread.group).to eql(group)
    end

    it 'should return a NilGroup when none are set' do
      expect(thread.group).to be_a Eldritch::NilGroup
    end
  end

  describe '#in_group?' do
    it 'should be false when group is nil' do
      thread.group = nil
      expect(thread.in_group?).to be_false
    end

    it 'should be false when group is a NilGroup' do
      thread.group = Eldritch::NilGroup.new
      expect(thread.in_group?).to be_false
    end

    it 'should be true when group is set' do
      thread.group = 2
      expect(thread.in_group?).to be_true
    end
  end
end