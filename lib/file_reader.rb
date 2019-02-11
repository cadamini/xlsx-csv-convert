class FileReader
  def self.run(path)
    Dir.glob(path)
  end
end