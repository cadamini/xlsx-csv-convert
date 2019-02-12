class CSVFileCreator
  
  def initialize(filename:, columns:, export_path:)
  	@filename = filename
  	@columns = columns
  	@export_path = export_path
  end

  def run
    build_file(injixo_formatted(temp_file), @filename)
  end

  private

  def temp_file
    RooClient.create(temp_file: "#{@filename}.temp", source_file: @filename)
  end

  def injixo_formatted(temp_file)
    Parser.new(
      type: :injixo,
      file: RooClient.read(temp_file: temp_file),
      column_index: @columns
    ).formatted_lines
  end

  def build_file(lines, filename)
    export = Exporter.new(
      lines: lines, export_path: @export_path,
      file: "#{filename}.export.#{Date.today}.csv")
    export.create_export_file
    File.delete(temp_file) # extract?
  end
end