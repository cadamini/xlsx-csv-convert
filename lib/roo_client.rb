require 'roo'

class RooClient
  def initialize(temp_file: nil, xlsx_file: nil)
    @temp_file = temp_file
    @xlsx_file = xlsx_file
  end

  def read_xlsx_file
    Roo::Excelx.new(@xlsx_file)
  end

  def read_temp_file
    Roo::CSV.new(@temp_file, csv_options: { col_sep: ';', quote_char: '|' })
  end
end