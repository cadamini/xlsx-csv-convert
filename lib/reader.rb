require 'csv'

class Reader 

  attr_reader :content, :filename

  def initialize(filename:)
    @filename = filename
    @content = CSV.parse(File.open(@filename))
  end

  def value_at(row:, column:)
    content[row][column]
  end
end
