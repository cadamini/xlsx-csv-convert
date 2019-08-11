require 'roo'
require 'pathname'
require 'date'
require 'fileutils'
require_relative 'lib/line'
require_relative 'lib/file_reader'

class Script 
  class << self

    def run
      files.each do |filename|
        csv_file = temporary_csv_from(filename)

        File.open(destination_for(filename), 'w+') do |f|
          
          FileReader.read(csv_file).each do |line|
            f.puts line
          end
        end
        File.delete("#{filename}.csv")
      end
      puts 'done.'
    end
  
    private

    def destination_for(filename)
      Pathname.new('export').join("#{File.basename(filename)}.csv")
    end
    
    def files
      FileReader.run_on('import')
    end

    def temporary_csv_from(filename)
      new_file = Roo::Excelx.new(filename)
      new_file.to_csv("#{filename}.csv", ';')
      new_file
    end
  end
end

Script.run