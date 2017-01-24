require 'sqlite3'
require 'config'

task 'db:create' do
  SQLite3::Database.new(Config[:root] + Config[:db_path] + 'default.db')
end
