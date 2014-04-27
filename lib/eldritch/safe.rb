require 'eldritch/version'
require 'eldritch/core_ext/thread'
require 'eldritch/task'
require 'eldritch/dsl'
require 'eldritch/group'
require 'eldritch/interrupted_error'

module Eldritch
  # Injects the DSL in the main
  #
  # This is automatically called when you call
  #   require 'eldritch'
  #
  # If you do not want to contaminate the main you can require +eldritch/safe+ and
  # include or extend Eldricth::DSL yourself.
  #
  #   require 'eldritch/safe'
  #   module Sandbox
  #     include Eldritch::DSL  # for async blocks, together and sync
  #     extend Eldritch::DSL   # for async method declaration
  #   end
  def self.inject_dsl
    Object.include Eldritch::DSL
  end
end
