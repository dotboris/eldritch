require 'spec_helper'
require 'eldritch/task'

describe Eldritch::Task do
  let(:task) { Eldritch::Task.new {} }
  let(:thread) { double(:thread).as_null_object }
  before do
    allow(Thread).to receive(:new).and_yield.and_return(thread)
  end

  it 'should not start a thread on init' do
    expect(task.thread).to be_nil
  end

  describe '#start' do
    it 'should create a thread' do
      task.start

      expect(task.thread).not_to be_nil
    end

    it 'should call the block' do
      expect do |b|
        task = Eldritch::Task.new &b
        task.start
      end.to yield_control
    end

    it 'should start a thread' do
      expect(Thread).to receive(:new).with(task)

      task.start
    end

    it 'should set the thread task' do
      expect(thread).to receive(:task=).with(task)

      task.start
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

  describe '#abort' do
    it 'should kill the thread' do
      expect(thread).to receive(:kill)

      task.start
      task.abort
    end
  end
end