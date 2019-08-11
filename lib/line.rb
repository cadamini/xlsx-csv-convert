require 'date'

class Line
  attr_reader :row

  def initialize(row)
    @row = row
    @date_col_idx = columns[:date]
    @queue_col_idx = columns[:queue_name]
    @aht_col_index = columns[:handling_time]
  end

  def invalid?
    row[0].is_a?(String) || row[1].is_a?(String)
  end

  def empty?
    row == [nil, nil, nil, nil, nil, nil, nil]
  end

  def injixo_format
    "#{queue};#{date};#{time};#{build_handling_time_sum};1"
  end

  private
  
  # how to make it configurable for the user
  def columns 
    {
      date: 4,
      queue_name: 2,
      handling_time: [6, 7] # mutiple elements or integer
    }
  end

  def date 
    row[@date_col_idx].strftime('%Y-%m-%d')
  end

  def time 
    row[@date_col_idx].strftime('%H:%M:%S')
  end

  def queue
    row[@queue_col_idx]
  end

  def handling_time
     @aht_col_index
  end

  def build_handling_time_sum
    if handling_time.is_a?(Array)
      handling_time.map { |i| row[i].to_i }.reduce(0, :+) 
    else
      row[handling_time].to_i
    end
  end
end