class FileReader
  def self.get_files_from(path)
    Dir.glob(path)
  end
end