class FileReader
  def self.run_on(folder)
    Dir.glob(Pathname.new(folder).join('*.xlsx'))
  end

  def self.read(csv_file)
    lines = []
    csv_file.each do |row|

      line = Line.new(row)
      next if line.empty?
      next if line.invalid?

      lines << line.injixo_format
    end
    lines
  end
end