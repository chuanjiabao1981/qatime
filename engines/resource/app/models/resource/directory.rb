module Resource
  class Directory < File
    has_many :files
  end
end
