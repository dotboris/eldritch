require 'eldritch/version'
require 'eldritch/task'
require 'eldritch/dsl'
require 'eldritch/ext_core/thread'
require 'eldritch/together'

module Eldritch
  def self.inject_dsl(klass)
    klass.extend Eldritch::DSL
    klass.include Eldritch::DSL
  end
end
