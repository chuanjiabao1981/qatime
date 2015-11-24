class CustomizedCourseStateChangeRecord  < CustomizedCourseActionRecord
  belongs_to :stateactionable,polymorphic: true,foreign_key: :actionable_id,foreign_type: :actionable_type

  def desc
    "1341234"
  end
end