class CustomizedCourseStateChangeRecord  < CustomizedCourseActionRecord
  belongs_to :stateactionable,polymorphic: true,foreign_key: :actionable_id,foreign_type: :actionable_type
end