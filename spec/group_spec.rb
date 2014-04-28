require 'spec_helper'
require 'eldritch/group'

describe Eldritch::Group do
  let(:group) { Eldritch::Group.new }

  describe '#<<' do
    it 'should start the task' do
      task = double('task')
      expect(task).to receive(:start)

      group << task
    end

    it 'should add the task to the list' do
      task = double('task').as_null_object

      group << task

      expect(group.others).to include(task)
    end

    context 'after it is aborted or interrupted' do
      before do
        group.abort
      end

      it 'should not start the task' do
        task = double('task')

        expect(task).not_to receive(:start)

        group << task
      end

      it 'should not add the task to the list' do
        task = double('task')

        group << task

        expect(group.others).not_to include(task)
      end
    end
  end

  describe '#others' do
    it 'should return an empty array when there is only one task' do
      task = double('task').as_null_object
      allow(Thread.current).to receive(:eldritch_task).and_return(task)

      group << task

      expect(group.others).to be_kind_of(Array)
      expect(group.others).to be_empty
    end

    it 'should return all the task except the current one' do
      task = double('task').as_null_object
      allow(Thread.current).to receive(:eldritch_task).and_return(task)
      other_task = double('other task').as_null_object

      group << task
      group << other_task

      expect(group.others).to eql([other_task])
    end
  end

  describe '#join_all' do
    it 'should call join on all tasks' do
      task = double('task')
      allow(task).to receive(:start)
      group << task

      expect(task).to receive(:join)

      group.join_all
    end
  end

  describe '#synchronize' do
    it 'should yield' do
      expect{|b| group.synchronize &b}.to yield_control
    end
  end

  describe '#abort' do
    it 'should call abort on all tasks' do
      task = double('task').as_null_object
      expect(task).to receive(:abort)

      group << task
      group.abort
    end

    it 'should not call abort on current task' do
      task = double('task').as_null_object
      expect(task).not_to receive(:abort)
      allow(Thread.current).to receive(:eldritch_task).and_return(task)

      group << task
      group.abort
    end
  end

  describe '#interrupt' do
    it 'should call interrupt on all tasks' do
      task = double('task').as_null_object
      expect(task).to receive(:interrupt)

      group << task
      group.interrupt
    end

    it 'should not call interrupt on current task' do
      task = double('task').as_null_object
      expect(task).not_to receive(:interrupt)
      allow(Thread.current).to receive(:eldritch_task).and_return(task)

      group << task
      group.interrupt
    end
  end
end

describe Eldritch::NilGroup do
  let(:group) { Eldritch::NilGroup.new }

  describe '#<<' do
    it 'should call the task' do
      task = double('task')
      expect(task).to receive(:start)

      group << task
    end
  end

  describe '#nil?' do
    it 'should be true' do
      expect(group.nil?).to be_true
    end
  end
end