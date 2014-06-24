namespace :qtfaststart do
  desc "install qtfast"
  task :install do
    on roles(:web) do |host|
      if test("[ -d /tmp/qtfaststart ]")
        execute 'rm -rf /tmp/qtfaststart'
      end
      execute 'cd /tmp;git clone https://github.com/danielgtaylor/qtfaststart.git'
      execute :sudo , 'cd /tmp/qtfaststart;python setup.py install'
    end
  end
end