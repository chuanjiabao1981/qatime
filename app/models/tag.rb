class Tag < ActsAsTaggableOn::Tag
  belongs_to :tag_group, counter_cache: true
  has_and_belongs_to_many :tag_categories

  def self.category_of(*names)
    query = self
    names.tap(&:flatten!).delete_if(&:blank?)
    return query.where('1 = 1') if names.blank?
    cate_conditions = names.map {"name = ?" }
    cate_ids = TagCategory.where(cate_conditions.join(" or "), *names).map(&:id)
    joins = []
    conditions = []
    conditions << "1 = 2" if cate_ids.blank?
    cate_ids.each_with_index do |id, i|
      joins << "LEFT OUTER JOIN tag_categories_tags AS tag_categories_tags_#{i} ON tag_categories_tags_#{i}.tag_id = tags.id"
      conditions << "tag_categories_tags_#{i}.tag_category_id = #{id}"
    end
    query.joins(joins.join(' '))
         .where(conditions.join(' AND '))
  end
end
