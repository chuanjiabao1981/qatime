class CreateSoftwareCategories < ActiveRecord::Migration
  def change
    create_table :software_categories do |t|
      t.string :title
      t.string :sub_title
      t.string :logo
      t.text :desc
      t.string :download_description
      t.integer :platform
      t.string :role
      t.string :category

      t.timestamps null: false
    end
    student_logo = File.open("#{Rails.root}/public/imgs/student-app.png")
    teacher_logo = File.open("#{Rails.root}/public/imgs/teacher-live.png")
    SoftwareCategory.create(title: '“答疑时间” 直播助手', sub_title: '在线直播教育专用', logo: teacher_logo, category: 'teacher_live',
                            desc: '答疑时间官方开发的直播软件，功能强大，操作容易，为辅导班直播量身定制，登录后选择课程即刻开启直播。', download_description: '现仅支持win7以上版本。', platform: 'windows', role: 'teacher')
    SoftwareCategory.create(title: '“答疑时间” 学生版 app', sub_title: '把辅导变成一件快乐有趣的事', logo: student_logo, category: 'student_client',
                            desc: '答疑时间学生版是一款为广大K12学生提供优质的辅导教师资源，通过直播方式进行授课，在线答疑解惑、实时互动；让线上学习不再枯燥。', download_description: '手机扫描右侧二维码即可下载仅支持 Android 4.0 以上版本。', platform: 'android', role: 'student')
    SoftwareCategory.create(title: '“答疑时间” 学生版 iOS app', sub_title: '把辅导变成一件快乐有趣的事', logo: student_logo, category: 'student_client',
                            desc: '答疑时间学生版是一款为广大K12学生提供优质的辅导教师资源，通过直播方式进行授课，在线答疑解惑、实时互动；让线上学习不再枯燥。', download_description: '手机扫描右侧二维码即可下载仅支持 IOS 10 以上版本。', platform: 'ios', role: 'student')

  end
end
