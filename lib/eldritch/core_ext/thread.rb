class Thread
  attr_writer :eldritch_group
  attr_accessor :eldritch_task

  def eldritch_group
    @eldritch_group ||= Eldritch::NilGroup.new
  end

  def in_eldritch_group?
    !eldritch_group.nil?
  end
end