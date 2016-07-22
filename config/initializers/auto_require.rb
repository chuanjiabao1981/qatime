# 自动加载目录
%W(app/apis).each do |d|
  Dir["#{Rails.root}/#{d}/*.rb"].each {|p| require p}
end
