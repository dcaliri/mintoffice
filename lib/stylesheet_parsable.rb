module StylesheetParsable
  extend ActiveSupport::Concern

  module ClassMethods
    def file_path(name)
      directory = "tmp"
      File.join(directory, name)
    end

    def create_file(path, file)
      File.open(path, "wb") { |f| f.write(file.read) }
    end

    def remove_file(path)
      File.delete(path)
    end
  end

  included do
    extend ClassMethods
  end
end