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

  def destination_file
    Pathname.new(@export_path).join(File.basename(@filename))
  end
end