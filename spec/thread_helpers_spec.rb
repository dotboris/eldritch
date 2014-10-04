require 'spec_helper'
require 'eldritch/thread_helpers'

describe Eldritch do
  describe '#group' do
    it 'should return a nil group when none are defined' do
      Thread.current[:_eldritch_group] = nil
      expect(Eldritch.group).to be_a Eldritch::NilGroup
    end
  end

  it 'should have a working accessor for group' do
    group = double('group')
    Eldritch.group = group

    expect(Eldritch.group).to eq(group)
  end
end