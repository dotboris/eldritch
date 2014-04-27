require 'spec_helper'
require 'eldritch/dsl'
require 'eldritch/task'
require 'eldritch/group'

describe Eldritch::DSL do
  let(:klass) do Class.new do
      extend Eldritch::DSL
      include Eldritch::DSL
    end
  end

  describe '#sync' do
    it 'should call task.value' do
      task = double(:task)
      expect(task).to receive(:value)
      klass.sync(task)
    end
  end

  describe '#together' do
    it 'should create a new group' do
      expect(Eldritch::Group).to receive(:new).and_return(double('group').as_null_object)

      klass.together {}
    end

    it 'should set the current thread group' do
      group = double('group').as_null_object
      allow(Eldritch::Group).to receive(:new).and_return(group)
      allow(Thread.current).to receive(:eldritch_group=).with(anything)

      expect(Thread.current).to receive(:eldritch_group=).with(group)

      klass.together {}
    end

    it 'should wait on all tasks' do
      group = double('group').as_null_object
      allow(Eldritch::Group).to receive(:new).and_return(group)

      expect(group).to receive(:wait_all)

      klass.together {}
    end

    it 'should reset the previous group when it is done' do
      group = double('group').as_null_object
      old_group = double('old group').as_null_object
      allow(Eldritch::Group).to receive(:new).and_return(group)
      allow(Thread.current).to receive(:eldritch_group).and_return(old_group)

      klass.together {}

      expect(Thread.current.eldritch_group).to eql(old_group)
    end

    it 'should yield it the new group' do
      group = double('group').as_null_object
      allow(Eldritch::Group).to receive(:new).and_return(group)

      expect{ |b| klass.together &b }.to yield_with_args(group)
    end
  end

  describe '#async' do
    let(:task) { double('task').as_null_object }
    let(:group) { double('group').as_null_object }

    before do
      call_me = nil
      allow(Eldritch::Task).to receive(:new) do |&block|
        call_me = block
        task
      end

      allow(group).to receive(:<<) do
        call_me.call(task)
      end

      allow(Thread.current).to receive(:eldritch_group).and_return(group)
    end

    context 'with 0 arguments' do
      it 'should add itself to the group' do
        expect(group).to receive(:<<).with(task)

        klass.async {}
      end

      it 'should return a task' do
        expect(klass.async {}).to eql(task)
      end

      it 'should set the task value' do
        expect(task).to receive(:value=).with('something')

        klass.async { 'something' }
      end

      it 'should eat any interrupted errors' do
        block = proc { raise Eldritch::InterruptedError }

        expect{klass.async &block}.not_to raise_error
      end
    end

    context 'with 1 argument' do
      before do
        klass.class_eval do
          def foo; end
          async :foo
        end
      end

      it 'should create a __async method' do
        expect(klass.new).to respond_to(:__async_foo)
      end

      it 'should redefine the method' do
        expect(klass).to receive(:define_method).with(:foo)

        klass.class_eval do
          def foo; end
          async :foo
        end
      end

      describe 'async method' do
        it 'should call the original' do
          instance = klass.new
          expect(instance).to receive(:__async_foo)

          instance.foo
        end

        it 'should pass all arguments' do
          klass.class_eval do
            def foo(_,_,_); end
            async :foo
          end
          instance = klass.new
          expect(instance).to receive(:__async_foo).with(1,2,3)

          instance.foo(1,2,3)
        end

        it 'should set the task value' do
          expect(task).to receive(:value=).with(42)

          klass.class_eval do
            def foo; 42; end
            async :foo
          end
          instance = klass.new

          instance.foo
        end
      end
    end
  end
end