class AddTranslateGroupGradeAndSubject < ActiveRecord::Migration
  def up
    Group.all.each do |group|
      if APP_CONFIG[group.grade.to_sym]
        group.grade   = APP_CONFIG[group.grade.to_sym].downcase
      end
      if APP_CONFIG[group.subject.to_sym]
        group.subject = APP_CONFIG[group.subject.to_sym].downcase
      end

      if group.save
      else
        puts group.errors.full_messages
        raise group.errors.full_messages
      end

    end

  end

  def down

  end

end
