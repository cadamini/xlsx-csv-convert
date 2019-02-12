require 'pathname'
require 'fileutils'

class Exporter
  def initialize(lines:, export_path:, file:)
    @lines = lines
    @export_path = export_path
    @file = file
  end

  def create_export_file
    puts "Exported to: #{destination}"
    File.open(destination, 'w+') do |f|
      @lines.each do |line|
        f.puts line
      end
    end
  end

  private

  def destination
    Pathname.new(@export_path).join(File.basename(@file))
  end
end
