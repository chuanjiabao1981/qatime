class TagParser < ActsAsTaggableOn::GenericParser
  def parse
    ActsAsTaggableOn::TagList.new.tap do |tag_list|
      tag_list.add @tag_list.split(/[;]\s*/)
    end
  end
end

ActsAsTaggableOn.default_parser = TagParser