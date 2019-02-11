require 'pathname'
require 'fileutils'

require_relative 'roo_client'
require_relative 'parser'
require_relative 'exporter'
require_relative 'file_reader'
require_relative 'csv_file_creator'

class Excel2CsvConvert
  attr_reader :column_positions
  def initialize(import_path: 'import', 
                 export_path: 'export',
                 column_positions: {
                   date: 5, queue_name: 3, handling_time: [6, 7]
                 }
    )
    @column_positions = column_positions
    @import_path = Pathname.new(import_path).join('*.xlsx')
    @export_path = export_path
  end

  def run
    FileReader.run(@import_path).each do |filename|
      puts "Reading #{filename} ..."
      CSVFileCreator.new(filename: filename, target_format: :injixo, column_positions: column_positions, export_path: @export_path).run
    end
  end
end