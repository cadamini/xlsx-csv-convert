require 'pathname'
require 'fileutils'

require_relative 'roo_client'
require_relative 'parser'
require_relative 'exporter'
require_relative 'file_reader'
require_relative 'csv_file_creator'

class Excel2CsvConvert
  class << self
    def run(export_path:, import_path:, columns: {})
      raise 'Specify positions in columns parameter as hash' if columns.empty?

      FileReader.get_files_from(full_path(path: import_path)).each do |filename|
        puts "Reading #{filename} ..."
        CSVFileCreator.new(
          filename: filename, columns: columns, export_path: export_path
        ).run
      end
    end

    private

    def full_path(path:)
      Pathname.new(path).join('*.xlsx')
    end
  end
end
