Dir["#{Rails.root}/lib/*.rb"].each {|p| require p}

# 自动加载目录
%W(app/apis).each do |d|
  Dir["#{Rails.root}/#{d}/*.rb"].each {|p| require p}
end

ActiveRecord::Base.send(:include, ActiveRecordExtend)