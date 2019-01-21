require 'pathname'
require 'fileutils'

class Exporter
  def initialize(lines:, export_path:, filename:)
    @lines = lines
    @export_path = export_path
    @filename = filename
  end

  def create_export
    puts "Exported to: #{destination_file}"
    File.open(destination_file, 'w+') do |f|
      @lines.each do |line|
        f.puts line
      end
    end
  end

  private

  def original_file_name
    File.basename(@filename)
  end

  def destination_file
    Pathname.new(@export_path).join(original_file_name)
  end
end