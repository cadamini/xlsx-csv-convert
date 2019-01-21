require 'date'
require_relative 'line'

class Parser
  attr_reader :column_positions, :row

  def initialize(target_format:, file:, column_positions:)
    @target_format = target_format
    @file = file
    @column_positions = column_positions
  end

  def parse(lines: [])
    @file.each_with_index do |row, row_num|
      next if date_row_empty?(row)
      begin
        lines << insert_lines(row, column_positions)
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
         "parsing failed in column #{column_positions[:date]}\n#{row}"
  end

  def date_row_empty?(row)
    row[column_positions[:date]].nil?
  end

  def insert_lines(row, column_positions)
    if @target_format == :injixo
      line = Line.new(row, column_positions).injixo_format
    elsif @target_format == :injixo_comma_separated
      line = Line.new(row, column_positions, separator: ',').comma_separated
    else
      raise "Unsupported format option -> #{@target_format}, use :injixo"
    end
    line
  end
end