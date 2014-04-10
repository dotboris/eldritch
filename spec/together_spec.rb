require 'spec_helper'
require 'eldritch/together'

describe Eldritch::Together do
  describe '#wait_all' do
    it 'should call wait on all tasks' do
      together = Eldritch::Together.new
      task = double('task')
      together << task

      expect(task).to receive(:wait)

      together.wait_all
    end
  end
end