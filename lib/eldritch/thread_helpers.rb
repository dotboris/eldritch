require 'eldritch/group'

module Eldritch
  def self.group
    Thread.current[:_eldritch_group] || NilGroup.new
  end

  def self.group=(group)
    Thread.current[:_eldritch_group] = group
  end
end