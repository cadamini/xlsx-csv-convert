require 'date'

class Line
  attr_reader :queue_name, :date_part, :time_part,
              :row, :separator, :col_idx

  def initialize(row, col_idx)
    @row = row
    @queue_name = row[col_idx[:queue_name]].delete('"')
    @col_idx = col_idx
  end

  def injixo_format
    "#{queue_name};#{parse_date_time(format: '%Y-%m-%d')};" \
    "#{parse_date_time(format: '%H:%M:%S')};#{build_handling_time(row)};1"
  end

  private

  def build_handling_time(row)
    if col_idx[:handling_time].is_a?(Array)
      values = col_idx[:handling_time].map { |i| row[i].to_i }
      values.reduce(0, :+)
    else
      row[col_idx[:handling_time]].to_i
    end
  end

  def parse_date_time(format:)
    DateTime.parse(row[col_idx[:date]]).strftime('%Y-%m-%d')
  end
end