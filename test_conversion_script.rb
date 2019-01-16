# Canyon xlsx File parser Version 0.1 (beta)

require 'roo'
require 'pathname'
require 'date'

class Converter
  class << self
    def xlsx_to_csv(xlsx_file:, csv_file: )
      xlsx = Roo::Excelx.new(xlsx_file)
      xlsx.to_csv(csv_file, ';')
      csv_file
    end

    def convert_canyon_call_csv_to_injixo_format(csv_file:)
      File.open(Pathname.new("export").join("#{Date.today}-converted-export-file.csv"), 'w+') do |f|
        csv = read(csv_file)
        convert(csv, f)
      end
    end

    private 

    def read(filename)
      Roo::CSV.new(filename, csv_options: { col_sep: ";", quote_char: '|' })
    end

    def injixo_format(row, date)
      queue_name = row[3].gsub("\"", "")
      date_part = date.strftime('%Y-%m-%d')
      time_part = date.strftime('%H:%M:%S')
      handling_time = row[6].to_i+row[7].to_i
      call_count = 1
      "#{queue_name};#{date_part};#{time_part};#{handling_time};#{call_count}"
    end

    def convert(csv, f)
      csv.each do |row|
          next if row[5].nil?
          begin
            date = parse(row[5])
          rescue ArgumentError # for strange lines at the end and subtotals
            next
          end
          f.puts injixo_format(row, date)
      end
    end

    def parse(cell)
      DateTime.parse(cell) # date 2018-12-13T08:45:59+00:00
    end
  end
end
# Usage 
# install ruby 
# copy this script somewhere
# create a folder export
# create a start.rb file 
# insert the following two lines

csv_file = Converter.xlsx_to_csv(xlsx_file: 'calls.xlsx', csv_file: 'converted_source_xlsx.csv')
Converter.convert_canyon_call_csv_to_injixo_format(csv_file: csv_file) # by default it creates time.now-converted-export-file.csv files in an export folder 

# run the file via ruby start.rb