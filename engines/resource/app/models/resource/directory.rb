module Resource
  class Directory < Resource::File
    has_many :files
  end
end
