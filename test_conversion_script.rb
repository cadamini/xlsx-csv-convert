# Canyon xlsx File parser Version 0.1 (beta)

require 'roo'
require 'pathname'
require 'date'
require 'fileutils'

class Parser
  attr_reader :column_positions

  def initialize(target_format:, file:, column_positions:)
    @target_format = target_format
    @file = file
    @column_positions = column_positions
  end

  def parse(lines: [])
    @file.each do |row|
      next if row[column_positions[:date]].nil?

      begin
        DateTime.parse(row[column_positions[:date]])
        if @target_format == :injixo
          lines << Line.new(row, column_positions).injixo_format
        else
          raise "Unsupported format option -> #{@target_format}, use :injixo"
        end
      rescue ArgumentError => e
        puts "Warning: Skipping line - #{e} #{row.inspect}"
        next
      end
    end
    lines
  end
end

class Exporter
  def self.create_export(lines:, export_path:)
    file = Pathname.new(export_path)
                   .join("#{Date.today}-converted-export-file.csv")
    File.open(file, 'w+') do |f|
      lines.each do |line|
        f.puts line
      end
    end
  end
end

class Cleaner
  def self.remove_temp_file(filename:)
    File.delete(filename)
  end
end

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

class XlsxConverter
  attr_reader :xlsx_file, :filename

  def initialize(filename:)
    @xlsx_file = RooClient.new(xlsx_file: filename).read_xlsx_file
    @filename = filename
  end

  # Alternative: modify xlsx and save to csv as last step
  # meaning working with content array, not persisted as file yet
  # xlsx.map { |line| line }
  # then return content, then use a csvfilebuilder

  def generate_temp_file
    save_csv(xlsx_file, destination_file)
    destination_file
  end

  private

  def destination_file
    "#{Date.today}-#{filename}.csv"
  end

  def save_csv(_xlsx, filename)
    xlsx_file.to_csv(filename, ';')
  end
end

class Line
  attr_reader :queue_name, :date_part, :time_part, :handling_time, :row

  def initialize(row, col_idx)
    @row = row
    @queue_name = row[col_idx[:queue_name]].delete('"')
    @handling_time = add_handling_time_columns(row, col_idx)
  end

  def injixo_format
    "#{queue_name};#{parsed_date};#{parsed_time};#{handling_time};1"
  end

  private

  # TODO: Refactor and / or extract to e.g. AhtBuilder Class
  def add_handling_time_columns(row, col_idx)
    row[col_idx[:handling_time][0]].to_i + row[col_idx[:handling_time][1]].to_i
  end

  def parsed_date
    parse(row[5]).strftime('%Y-%m-%d')
  end

  def parsed_time
    parse(row[5]).strftime('%H:%M:%S')
  end

  def parse(cell)
    DateTime.parse(cell)
  end
end

# TODO: check how a single time column can be implemented
class Excel2CsvConvert
  attr_reader :column_positions
  def initialize(xlsx_filename:, export_path: 'export',
                 column_positions: {
                   date: 5, queue_name: 3, handling_time: [6, 7]
                 },
                 target_format: :injixo)
    @xlsx_filename = xlsx_filename
    @export_path = FileUtils.mkdir_p(export_path).first
    @target_format = target_format
    @column_positions = column_positions
  end

  def run
    temp_file = XlsxConverter.new(
      filename: @xlsx_filename
    ).generate_temp_file

    lines = Parser.new(
      target_format: @target_format,
      file: RooClient.new(temp_file: temp_file).read_temp_file,
      column_positions: @column_positions
    ).parse

    Exporter.create_export(lines: lines, export_path: @export_path)

    Cleaner.remove_temp_file(filename: temp_file)
  end

  private

  def parse(cell)
    DateTime.parse(cell)
  end
end

# USAGE
# install ruby
# copy this script somewhere
# create a start.rb file
# insert the following two lines
# then ruby start.rb

options = {
  xlsx_filename: 'calls.xlsx',
  column_positions: {
    date: 5,
    queue_name: 3,
    handling_time: [6, 7]
  },
  target_format: :injixo
}
Excel2CsvConvert.new(options).run
