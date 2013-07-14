class Search

  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  
  attr_accessor :keywords, :element, :method

  def persisted?
    false
  end

end
