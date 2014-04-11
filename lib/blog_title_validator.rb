require './lib/blog_title_validation_result'

class BlogTitleValidator

  def initialize(db)
    @posts_table = db[:posts]
  end

  def validate(title, subtitle)
    if !@posts_table[:title => title].nil? && !@posts_table[:subtitle => subtitle].nil?
      BlogTitleValidationResult.new(false, "That blog title has already been chosen.")
    else
      BlogTitleValidationResult.new(true, "")
    end
  end
end