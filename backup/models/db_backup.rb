# encoding: utf-8

##
# Backup Generated: db_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t db_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#

require "backup-aliyun"

environment         = ENV["BACKUP_ENV"] || "development"
current_dir         = File.dirname(__FILE__)
db_config           = YAML.load_file("#{current_dir}/../../config/database.yml")[environment]
app_config          = YAML.load_file("#{current_dir}/../../config/application.yml")[environment]

Logger.info db_config


Model.new(:db_backup, 'Description for db_backup') do
  ##
  # PostgreSQL [Database]
  #
  database PostgreSQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = db_config['database']
    db.username           = db_config['username']
    db.password           = db_config['password']
    db.host               = "localhost"
    db.port               = 5432
    #db.socket             = "/tmp/pg.sock"
    # When dumping all databases, `skip_tables` and `only_tables` are ignored.
    #db.skip_tables        = ["skip", "these", "tables"]
    #db.only_tables        = ["only", "these", "tables"]
    #db.additional_options = ["-xc", "-E=utf8"]
  end

  ##
  # Local (Copy) [Storage]
  #
  # store_with Local do |local|
  #   local.path       = "~/backups/"
  #   local.keep       = 10
  #   local.keep       = Time.now - 2592000 # Remove all backups older than 1 month.
  # end

  store_with "Aliyun" do |aliyun|
    aliyun.access_key_id        = app_config['aliyun_backup_ac']
    aliyun.access_key_secret    = app_config['aliyun_backup_ak']
    aliyun.bucket               = app_config['bucket_backup']
    aliyun.path                 = '/database/'
    aliyun.keep                 = 10
    aliyun.aliyun_area          = 'cn-beijing'
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

end
