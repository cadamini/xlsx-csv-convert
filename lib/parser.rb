require_relative 'line'

class Parser
  attr_reader :column_index, :row

  def initialize(type:, file:, column_index:)
    @type = type
    @file = file
    @column_index = column_index
  end

  def formatted_lines(lines: [])
    @file.each_with_index do |row, row_num|
      next if empty_date?(row)
      begin
        lines << new_format(row, column_index)
      rescue ArgumentError => e
        print_warnings(row_num, e)
        next
      end
    end
    lines
  end

  private

  def print_warnings(row_num, e)
    puts "Skipped line #{row_num + 1} - #{e}," \
         "parsing failed in column #{column_index[:date]}\n#{row}"
  end

  def empty_date?(row)
    row[column_index[:date]].nil?
  end

  def new_format(row, column_index)
    if @type == :injixo
      line = Line.new(row, column_index).injixo_format
    else
      raise "Unsupported format option -> #{@type}, use :injixo"
    end
    line
  end
end