require 'roo'

class RooClient
  def self.read(temp_file:)
    Roo::CSV.new(temp_file, csv_options: { col_sep: ';', quote_char: '|' })
  end

  def self.create(temp_file:, source_file:)
    Roo::Excelx.new(source_file).to_csv(temp_file, ';')
    temp_file
  end
end
