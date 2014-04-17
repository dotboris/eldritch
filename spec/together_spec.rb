require 'spec_helper'
require 'eldritch/together'

describe Eldritch::Together do
  let(:together) { Eldritch::Together.new }

  describe '#<<' do
    it 'should start the task' do
      task = double('task')
      expect(task).to receive(:start)

      together << task
    end
  end

  describe '#wait_all' do
    it 'should call wait on all tasks' do
      task = double('task')
      allow(task).to receive(:start)
      together << task

      expect(task).to receive(:wait)

      together.wait_all
    end
  end
end

describe Eldritch::NilTogether do
  let(:together) { Eldritch::NilTogether.new }

  specify { expect(together).to respond_to(:wait_all) }

  describe '#<<' do
    it 'should call the task' do
      task = double('task')
      expect(task).to receive(:start)

      together << task
    end
  end

  describe '#nil?' do
    it 'should be true' do
      expect(together.nil?).to be_true
    end
  end
end