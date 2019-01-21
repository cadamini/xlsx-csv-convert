require 'date'
require_relative 'line'

class Parser
  attr_reader :col_idx, :row

  def initialize(target_format:, file:, col_idx:)
    @target_format = target_format
    @file = file
    @col_idx = col_idx
  end

  def parse(lines: [])
    @file.each_with_index do |row, row_num|
      next if empty_date?(row)
      begin
        lines << insert_lines(row, col_idx)
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
         "parsing failed in column #{col_idx[:date]}\n#{row}"
  end

  def empty_date?(row)
    row[col_idx[:date]].nil?
  end

  def insert_lines(row, col_idx)
    if @target_format == :injixo
      line = Line.new(row, col_idx).injixo_format
    elsif @target_format == :injixo_comma_separated
      line = Line.new(row, col_idx, separator: ',').comma_separated
    else
      raise "Unsupported format option -> #{@target_format}, use :injixo"
    end
    line
  end
end