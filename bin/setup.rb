#!/usr/bin/env ruby
require 'pathname'

# path to your application root.
APP_ROOT = Pathname.new File.expand_path('../../', __FILE__)

ROW_SIZE = 80

# 增加shell颜色
class String
  # 日志颜色
  COLORS = {
    red: 31,
    green: 32,
    yellow: 33,
    blue: 34
  }.freeze

  def colorize(color)
    "\033[#{COLORS[color]}m#{self}\033[0m"
  end
end

def puts_section(info, &block)
  puts info
  puts '-' * ROW_SIZE
  yield block
  puts '-' * ROW_SIZE
  puts ''
end

def puts_line(info, &block)
  print info
  rsize = ROW_SIZE - info.length
  success = yield block
  if success == false
    puts '[Failed]'.rjust(rsize).colorize(:red)
  else
    puts '[Done]'.rjust(rsize).colorize(:green)
  end
end

def puts_line_with_yn(info, &block)
  print info
  rsize = ROW_SIZE - info.length
  success = yield block
  if success == false
    puts '[No]'.rjust(rsize).colorize(:red)
  else
    puts '[Yes]'.rjust(rsize).colorize(:green)
  end
end

def replace_file(file_name, from, to)
  File.open(file_name, 'r+') do |f|
    out = ''
    f.each do |line|
      out << line.gsub(from, to)
    end
    f.pos = 0
    f.print out
    f.truncate(f.pos)
  end
end

Dir.chdir APP_ROOT do
  # This script is a starting point to setup your application.
  # Add necessary setup steps to this file.

  puts_section 'Checking Package Dependencies...' do
    pkg_exist = true
    [['psql', 'PostgreSQL 9.3+']].each do |item|
      puts_line_with_yn item[1] do
        if `which #{item[0]}` == ''
          pkg_exist = false
          false
        else
          true
        end
      end
    end

    exit(0) if pkg_exist == false
  end

  puts_section 'Installing dependencies' do
    system 'gem install bundler --conservative'
    system 'bundle check || bundle install'
  end

  # Config files
  puts_section 'Configure' do
    %w(database application wechat).each do |fname|
      # system "cp config/#{fname}.yml.example config/#{fname}.yml"
    end
  end

  puts_line 'Seed default data...' do
    `bundle exec rake db:setup`
  end

  puts "\n== Removing old logs and tempfiles =="
  system 'rm -f log/*'
  system 'rm -rf tmp/cache'

  puts ''
  puts 'QATime Successfully Installed.'
end