require 'spec_helper'
require 'eldritch/task'

describe Eldritch::Task do
  let(:task) { Eldritch::Task.new {} }

  it 'should not start a thread on init' do
    expect(task.thread).to be_nil
  end

  describe '#start' do
    it 'should create a thread' do
      task.start

      expect(task.thread).not_to be_nil
    end

    it 'should call the block' do
      allow(Thread).to receive(:new).and_yield
      expect do |b|
        task = Eldritch::Task.new &b
        task.start
      end.to yield_control
    end
  end

  describe '#wait' do
    it 'should join the thread' do
      task.start

      expect(task.thread).to receive(:join)
      task.wait
    end
  end

  describe '#value' do
    it 'should join the thread' do
      task.start

      expect(task.thread).to receive(:join)
      task.value
    end

    it 'should return the value' do
      task.value = 42
      task.start
      expect(task.value).to eql(42)
    end
  end
end