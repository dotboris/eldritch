require 'eldritch/version'
require 'eldritch/refinements/thread'
require 'eldritch/task'
require 'eldritch/dsl'
require 'eldritch/group'
require 'eldritch/interrupted_error'

module Eldritch
  def self.inject_dsl
    Object.include Eldritch::DSL
  end
end
