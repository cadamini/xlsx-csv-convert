require_relative 'roo_client'

class XlsxConverter
  attr_reader :xlsx_file, :filename

  def initialize(filename:, temp_file:)
    @xlsx_file = RooClient.new(xlsx_file: filename).read_xlsx_file
    @temp_file = temp_file
  end

  def generate_temp_file(separator: ';')
    xlsx_file.to_csv(@temp_file, separator)
    @temp_file
  end
end