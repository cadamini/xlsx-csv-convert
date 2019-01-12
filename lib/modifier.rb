
class Modifier
  attr_reader :file_content

  def initialize(file_content:)
    @file_content = file_content
  end

  def duplicate
    file_content * 2
  end

  def new_default_column_value(value)
    file_content.each do |line|
      line << value
    end
  end

  # rework, format must be the same currently
  def add_remote_cell_value(source_content:, column_position:)
    file_content.each_with_index do |line, index|
      if source_content[column_position].nil? 
        raise "column index #{column_position} out of bounds" 
      end
      line << source_content[index][column_position]

    end
  end

  def convert_time_to_seconds(column_position:)
    file_content.each_with_index do |line, index|
      time_value = line[column_position].split(':')
      hours = time_value[0].to_i * 3600 # extract?
      minutes = time_value[1].to_i * 60
      seconds = time_value[2].to_i
      line[column_position] = hours + minutes + seconds
    end
  end

  def remove_quotation_marks
    new_file = CSV.generate(col_sep: ",", :force_quotes => false) do |csv|

      file_content.each_with_index do |line, index|
        csv << line.map! { |element| element || element.gsub!("\"", "") }
      end 
      new_file
    end
  end

  def change_separator_to(separator:)
    file_content.map do |row| row.to_csv(col_sep: separator) end;
  end

  def remove_headers(lines:)
    0.upto(lines).each do |i|
      file_content.delete_at(i)
    end
    file_content
  end
end