class Thread
  attr_writer :together
  attr_accessor :task

  def together
    @together ||= Eldritch::NilTogether.new
  end

  def together?
    !together.nil?
  end
end