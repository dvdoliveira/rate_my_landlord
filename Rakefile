require 'rake'
require "sinatra/activerecord/rake"
require 'active_record/schema_dumper'
require ::File.expand_path('../config/environment', __FILE__)

Rake::Task["db:create"].clear
Rake::Task["db:drop"].clear

DATABASE_PATH = File.absolute_path("db/db.sqlite3", File.dirname(__FILE__))

# NOTE: Assumes SQLite3 DB

desc "create the database"
task "db:create" do
  touch 'db/db.sqlite3'
end

desc "drop the database"
task "db:drop" do
  rm_f 'db/db.sqlite3'
end

task 'db:create_migration' do
  unless ENV["NAME"]
    puts "No NAME specified. Example usage: `rake db:create_migration NAME=create_users`"
    exit
  end

  name    = ENV["NAME"]
  version = ENV["VERSION"] || Time.now.utc.strftime("%Y%m%d%H%M%S")

  ActiveRecord::Migrator.migrations_paths.each do |directory|
    next unless File.exist?(directory)
    migration_files = Pathname(directory).children
    if duplicate = migration_files.find { |path| path.basename.to_s.include?(name) }
      puts "Another migration is already named \"#{name}\": #{duplicate}."
      exit
    end
  end

  filename = "#{version}_#{name}.rb"
  dirname  = ActiveRecord::Migrator.migrations_path
  path     = File.join(dirname, filename)

  FileUtils.mkdir_p(dirname)
  File.write path, <<-MIGRATION.strip_heredoc
    class #{name.camelize} < ActiveRecord::Migration
      def change
      end
    end
  MIGRATION

  puts path
end

desc 'dump the database'
task 'db:schema:dump' do
  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: DATABASE_PATH
  )
  filename = File.absolute_path('db/schema.rb', File.dirname(__FILE__))
  File.open(filename, 'w:utf-8') do |file|
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
  end
end

desc 'migrate the database (options: VERSION=x, VERBOSE=false, SCOPE=blog).'
task 'db:migrate' do
    ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: DATABASE_PATH
  )
  ActiveRecord::Migration.verbose = ENV['VERBOSE'] ? ENV['VERBOSE'] == 'true' : true
  ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, ENV['VERSION'] ? ENV['VERSION'].to_i : nil) do |migration|
    ENV['SCOPE'].blank? || (ENV['SCOPE'] == migration.scope)
  end
  Rake::Task['db:schema:dump'].invoke
end

desc 'rollback the database (options: VERSION=x, VERBOSE=false, STEPS=1).'
task 'db:rollback' do
    ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: DATABASE_PATH
  )
  ActiveRecord::Migration.verbose = ENV['VERBOSE'] ? ENV['VERBOSE'] == 'true' : true
  ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, ENV['STEPS'] ? ENV['STEPS'].to_i : 1)
  Rake::Task['db:schema:dump'].invoke
end

desc 'Retrieves the current schema version number'
task "db:version" do
  puts "Current version: #{ActiveRecord::Migrator.current_version}"
end
