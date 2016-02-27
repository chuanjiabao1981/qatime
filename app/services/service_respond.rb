class ServiceRespond
  def initialize
    @errors = []
  end

  def success?
    return true if @errors.length == 0
    return false
  end

  def add_error(err)
    @errors << err
    self
  end

  def errors
    return @errors
  end

end