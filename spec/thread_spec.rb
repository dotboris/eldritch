require 'spec_helper'
require 'eldritch/ext_core/thread'

describe Thread do
  it 'should have together accessor' do
    t = Thread.new {}
    expect(t).to respond_to(:together)
    expect(t).to respond_to(:together=)
  end

  describe '#together?' do
    it 'should be false when together is nil' do
      t = Thread.new {}
      t.together = nil
      expect(t.together?).to be_false
    end

    it 'should be true when together is set' do
      t = Thread.new {}
      t.together = 2
      expect(t.together?).to be_true
    end
  end
end