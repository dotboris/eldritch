require 'spec_helper'
require 'eldritch/ext_core/thread'

describe Thread do
  let(:thread) { Thread.new {} }

  it 'should have together accessor' do
    expect(thread).to respond_to(:together)
    expect(thread).to respond_to(:together=)
  end

  it 'should have a task accessor' do
    expect(thread).to respond_to(:task)
    expect(thread).to respond_to(:task=)
  end

  describe '#together' do
    it 'should return the togther previously set' do
      together = double('together')
      thread.together = together
      expect(thread.together).to eql(together)
    end

    it 'should return a NilTogether when none are set' do
      expect(thread.together).to be_a Eldritch::NilTogether
    end
  end

  describe '#together?' do
    it 'should be false when together is nil' do
      thread.together = nil
      expect(thread.together?).to be_false
    end

    it 'should be false when together is a NilTogether' do
      thread.together = Eldritch::NilTogether.new
      expect(thread.together?).to be_false
    end

    it 'should be true when together is set' do
      thread.together = 2
      expect(thread.together?).to be_true
    end
  end
end