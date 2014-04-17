require 'spec_helper'
require 'eldritch/dsl'
require 'eldritch/task'
require 'eldritch/together'

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
    it 'should create a new together' do
      expect(Eldritch::Together).to receive(:new).and_return(double('together').as_null_object)

      klass.together {}
    end

    it 'should set the current thread together' do
      together = double('together').as_null_object
      allow(Eldritch::Together).to receive(:new).and_return(together)
      allow(Thread.current).to receive(:together=).with(nil)

      expect(Thread.current).to receive(:together=).with(together)

      klass.together {}
    end

    it 'should wait on all tasks' do
      together = double('together').as_null_object
      allow(Eldritch::Together).to receive(:new).and_return(together)

      expect(together).to receive(:wait_all)

      klass.together {}
    end

    it 'should leave current thread together nil' do
      together = double('together').as_null_object
      allow(Eldritch::Together).to receive(:new).and_return(together)

      klass.together {}

      expect(Thread.current.together).to be_nil
    end
  end

  describe '#async' do
    let(:task) { double('task').as_null_object }
    let(:together) { double('together').as_null_object }

    before do
      call_me = nil
      allow(Eldritch::Task).to receive(:new) do |&block|
        call_me = block
        task
      end

      allow(together).to receive(:<<) do
        call_me.call(task)
      end

      allow(Thread.current).to receive(:together).and_return(together)
    end

    context 'with 0 arguments' do
      it 'should add itself to the together' do
        expect(together).to receive(:<<).with(task)

        klass.async {}
      end

      it 'should return a task' do
        expect(klass.async {}).to eql(task)
      end

      it 'should set the task value' do
        expect(task).to receive(:value=).with('something')

        klass.async { 'something' }
      end
    end

    context 'with 1 argument' do
      before do
        klass.class_eval do
          async def foo; end
        end
      end

      it 'should create a __async method' do
        expect(klass.new).to respond_to(:__async_foo)
      end

      it 'should redefine the method' do
        expect(klass).to receive(:define_method).with(:foo)

        klass.class_eval do
          async def foo; end
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
            async def foo(_,_,_); end
          end
          instance = klass.new
          expect(instance).to receive(:__async_foo).with(1,2,3)

          instance.foo(1,2,3)
        end

        it 'should set the task value' do
          expect(task).to receive(:value=).with(42)

          klass.class_eval do
            async def foo; 42; end
          end
          instance = klass.new

          instance.foo
        end

        it 'should return a task' do
          allow(Eldritch::DSL).to receive(:new).and_return(double(:task).as_null_object)

          instance = klass.new

          expect(instance.foo).to eql(task)
        end

        it 'should add itself to the together' do
          expect(together).to receive(:<<).with(task)

          klass.new.foo
        end
      end
    end
  end
end