require 'spec_helper'
require 'eldritch/group'

describe Eldritch::Group do
  let(:together) { Eldritch::Group.new }

  describe '#<<' do
    it 'should start the task' do
      task = double('task')
      expect(task).to receive(:start)

      together << task
    end

    it 'should add the task to the list' do
      task = double('task').as_null_object

      together << task

      expect(together.others).to include(task)
    end

    context 'after it is aborted or interrupted' do
      before do
        together.abort
      end

      it 'should not start the task' do
        task = double('task')

        expect(task).not_to receive(:start)

        together << task
      end

      it 'should not add the task to the list' do
        task = double('task')

        together << task

        expect(together.others).not_to include(task)
      end
    end
  end

  describe '#others' do
    it 'should return an empty array when there is only one task' do
      task = double('task').as_null_object
      allow(Thread.current).to receive(:task).and_return(task)

      together << task

      expect(together.others).to be_kind_of(Array)
      expect(together.others).to be_empty
    end

    it 'should return all the task except the current one' do
      task = double('task').as_null_object
      allow(Thread.current).to receive(:task).and_return(task)
      other_task = double('other task').as_null_object

      together << task
      together << other_task

      expect(together.others).to eql([other_task])
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

  describe '#synchronize' do
    it 'should yield' do
      expect{|b| together.synchronize &b}.to yield_control
    end
  end

  describe '#abort' do
    it 'should call abort on all tasks' do
      task = double('task').as_null_object
      expect(task).to receive(:abort)

      together << task
      together.abort
    end

    it 'should not call abort on current task' do
      task = double('task').as_null_object
      expect(task).not_to receive(:abort)
      allow(Thread.current).to receive(:task).and_return(task)

      together << task
      together.abort
    end
  end

  describe '#interrupt' do
    it 'should call interrupt on all tasks' do
      task = double('task').as_null_object
      expect(task).to receive(:interrupt)

      together << task
      together.interrupt
    end

    it 'should not call interrupt on current task' do
      task = double('task').as_null_object
      expect(task).not_to receive(:interrupt)
      allow(Thread.current).to receive(:task).and_return(task)

      together << task
      together.interrupt
    end
  end
end

describe Eldritch::NilGroup do
  let(:together) { Eldritch::NilGroup.new }

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