require 'date'

class Line
  attr_reader :queue_name, :date_part, :time_part, :handling_time,
              :row, :separator, :column_positions

  def initialize(row, column_positions, separator: ';')
    @row = row
    @queue_name = row[column_positions[:queue_name]].delete('"')
    @handling_time = sum_up_handling_time_array_elements(row, column_positions)
    @separator = separator
    @column_positions = column_positions
  end

  # TODO: more flexible creation with Builder class?
  def injixo_format
    "#{queue_name};#{parsed_date};#{parsed_time};#{handling_time};1"
  end

  def comma_separated
    "#{queue_name}#{separator}#{parsed_date}#{separator}#{parsed_time}" \
    "#{separator}#{handling_time}#{separator}1"
  end

  private

  def sum_up_handling_time_array_elements(row, column_positions)
    if column_positions[:handling_time].is_a?(Array)
      values = column_positions[:handling_time].map { |i| row[i].to_i }
      values.reduce(0, :+)
    else
      row[column_positions[:handling_time]].to_i
    end
  end

  def parsed_date
    parse(row[column_positions[:date]]).strftime('%Y-%m-%d')
  end

  def parsed_time
    parse(row[column_positions[:date]]).strftime('%H:%M:%S')
  end

  # extract?
  def convert_time_to_seconds
    time_value = line[:date].split(':')
    hours = time_value[0].to_i * 3600
    minutes = time_value[1].to_i * 60
    seconds = time_value[2].to_i
    line[:date] = hours + minutes + seconds
  end

  def parse(cell)
    DateTime.parse(cell)
  end
end