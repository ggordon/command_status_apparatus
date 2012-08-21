$LOAD_PATH << "." unless $LOAD_PATH.include?(".")
require 'logger'

require 'rubygems'
#require 'bundler'

#Bundler.setup
#Bundler.require

require 'bundler/setup'

require File.expand_path('../../lib/command_status_apparatus', __FILE__)

db_name = 'sqlite3'
database_yml = File.expand_path('../database.yml', __FILE__)

if File.exists?(database_yml)
  active_record_configuration = YAML.load_file(database_yml)
  
  ActiveRecord::Base.configurations = active_record_configuration
  config = ActiveRecord::Base.configurations[db_name]
  
  begin
    ActiveRecord::Base.establish_connection(db_name)
    ActiveRecord::Base.connection
  rescue
    ActiveRecord::Base.establish_connection(config)
  end
    
  ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))
  ActiveRecord::Base.default_timezone = :utc
  
  ActiveRecord::Base.silence do
    ActiveRecord::Migration.verbose = false
    
    load(File.dirname(__FILE__) + '/schema.rb')
    #load(File.dirname(__FILE__) + '/models.rb')
  end  
  
else
  raise "Please create #{database_yml} first to configure your database. Take a look at: #{database_yml}.sample"
end

def clean_database!
  models = [CommandStatus]
  models.each do |model|
    ActiveRecord::Base.connection.execute "DELETE FROM #{model.table_name}"
  end
end

clean_database!

require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
  add_group  'Libraries', 'lib'
end

require 'turn/autorun'


