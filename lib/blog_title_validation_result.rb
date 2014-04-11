class BlogTitleValidationResult
  attr_reader :error_message

  def initialize(success, error_message)
    @success = success
    @error_message = error_message
  end

  def success?
    @success
  end
end