class CSVFileCreator
  
  def initialize(filename:, target_format:, column_positions:, export_path:)
  	@filename = filename
  	@target_format = target_format
  	@column_positions = column_positions
  	@export_path = export_path
  end

  def run
  	parsed_file_content = parse(temp_file)
    export(parsed_file_content, @filename)
    File.delete(temp_file)
  end

  private

  def temp_file
    RooClient.new(
      source_file: @filename, temp_file: "#{@filename}.temp"
    ).generate_temp_csv
  end

  def parse(filename)
    Parser.new(
      type: @target_format,
      file: RooClient.new(temp_file: filename).read,
      column_index: @column_positions
    ).parse
  end

   # TODO: Exporter still handles file creation on its own
  def export(lines, filename)
    export = Exporter.new(
      lines: lines, export_path: @export_path,
      file: "#{filename}.export.#{Date.today}.csv")
    export.run
  end
end