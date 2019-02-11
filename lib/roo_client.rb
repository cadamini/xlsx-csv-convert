require 'roo'

class RooClient
  def initialize(temp_file: nil, source_file: nil)
    @temp_file = temp_file
    @source_file = source_file
  end

  def read_source
    Roo::Excelx.new(@source_file)
  end

  def read
    Roo::CSV.new(@temp_file, csv_options: { col_sep: ';', quote_char: '|' })
  end

  def generate_temp_csv
    read_source.to_csv(@temp_file, ';')
    @temp_file
  end
end