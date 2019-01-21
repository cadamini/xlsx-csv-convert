require 'roo'
require 'pathname'
require 'date'
require 'fileutils'

require_relative 'xlsx_converter'
require_relative 'parser'
require_relative 'exporter'

class Excel2CsvConvert
  attr_reader :column_positions
  def initialize(target_format: :injixo, keep_tempfile: false,
                 column_positions: {
                   date: 5, queue_name: 3, handling_time: [6, 7]
                 }, import_path: 'import', export_path: 'export')
    @target_format = target_format
    @column_positions = column_positions
    @keep_tempfile = keep_tempfile
    @import_path = Pathname.new(import_path).join('*.xlsx')
    @export_path = export_path
  end

  def run
    Dir.glob(@import_path).each do |filename|
      puts "Reading #{filename} ..."
      temp_file = create_temp_file_for(filename)
      export_csv_file(read_and_convert(temp_file), filename)
      File.delete(temp_file) unless @keep_tempfile
    end
  end

  private

  def read_and_convert(temp_file)
    Parser.new(
      target_format: @target_format,
      file: RooClient.new(temp_file: temp_file).read_temp_file,
      column_positions: @column_positions
    ).parse
  end

  # TODO: Exporter still handles file creation on its own
  def export_csv_file(lines, filename)
    Exporter.new(lines: lines, export_path: @export_path,
                 filename: "#{filename}.export.#{Date.today}.csv").create_export
  end

  def create_temp_file_for(filename)
    XlsxConverter.new(
      filename: filename, temp_file: "#{filename}.temp"
    ).generate_temp_file
  end
end