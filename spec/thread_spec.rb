require 'spec_helper'
require 'eldritch/core_ext/thread'

describe Thread do
  let(:thread) { Thread.new {} }

  it 'should have group accessor' do
    expect(thread).to respond_to(:eldritch_group)
    expect(thread).to respond_to(:eldritch_group=)
  end

  it 'should have a task accessor' do
    expect(thread).to respond_to(:eldritch_task)
    expect(thread).to respond_to(:eldritch_task=)
  end

  describe '#group' do
    it 'should return the togther previously set' do
      group = double('group')
      thread.eldritch_group = group
      expect(thread.eldritch_group).to eql(group)
    end

    it 'should return a NilGroup when none are set' do
      expect(thread.eldritch_group).to be_a Eldritch::NilGroup
    end
  end

  describe '#in_group?' do
    it 'should be false when group is nil' do
      thread.eldritch_group = nil
      expect(thread.in_eldritch_group?).to be_false
    end

    it 'should be false when group is a NilGroup' do
      thread.eldritch_group = Eldritch::NilGroup.new
      expect(thread.in_eldritch_group?).to be_false
    end

    it 'should be true when group is set' do
      thread.eldritch_group = 2
      expect(thread.in_eldritch_group?).to be_true
    end
  end
end