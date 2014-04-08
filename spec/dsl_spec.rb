require 'spec_helper'
require 'eldritch/dsl'
require 'eldritch/task'

describe Eldritch::DSL do
  describe '#async(method)' do
    let(:klass) do Class.new do
        extend Eldritch::DSL
      end
    end

    it 'should create a __async method' do
      klass.class_eval do
        async def foo; end
      end

      expect(klass.new).to respond_to(:__async_foo)
    end

    it 'should redefine the method' do
      expect(klass).to receive(:define_method).with(:foo)

      klass.class_eval do
        async def foo; end
      end
    end

    describe 'async method' do
      it 'should start a new thread' do
        expect(Thread).to receive(:new).once

        klass.class_eval do
          async def foo; end
        end

        klass.new.foo
      end

      it 'should call the original' do
        allow(Thread).to receive(:new).and_yield(double(:task).as_null_object)

        klass.class_eval do
          async def foo; end
        end
        instance = klass.new
        expect(instance).to receive(:__async_foo)

        instance.foo
      end

      it 'should pass all arguments' do
        allow(Thread).to receive(:new).and_yield(double(:task).as_null_object)

        klass.class_eval do
          async def foo(a,b,c); end
        end
        instance = klass.new
        expect(instance).to receive(:__async_foo).with(1,2,3)

        instance.foo(1,2,3)
      end

      it 'should set the task value' do
        task = double(:task)
        expect(task).to receive(:value=).with(42)
        allow(Thread).to receive(:new).and_yield(task)

        klass.class_eval do
          async def foo; 42; end
        end
        instance = klass.new

        instance.foo
      end

      it 'should return a task' do
        allow(Thread).to receive(:new).and_yield(double(:task).as_null_object)

        klass.class_eval do
          async def foo; end
        end
        instance = klass.new

        expect(instance.foo).to be_a(Eldritch::Task)
      end

      it 'should start the task' do
        task = double(:task)
        expect(task).to receive(:start).once
        allow(Eldritch::Task).to receive(:new).and_return(task)
        allow(Thread).to receive(:new).and_yield(double(:task).as_null_object)

        klass.class_eval do
          async def foo; end
        end
        instance = klass.new

        instance.foo
      end
    end
  end
end