module Model
  # model base
  class Base
    class << self
      # def init
      #   require 'app/db/migration/' + self.name.downcase + '_migration'
      #   klass = self.name + 'Migration'
      #   ins = Kernel.const_get(klass).new
      #   ins.column
      # end

      def all
        result = nil
        SQLite3::Database.new(db_name) do |db|
          result = db.execute("SELECT * FROM #{table_name}")
        end
        result
      end

      # カラム名
      def find_by(hash)
        key, val = ''
        result = nil
        hash.each do |k, v|
          key = k.to_s
          val = v
        end
        SQLite3::Database.new(db_name) do |db|
          result = db.execute("SELECT * FROM #{table_name} WHERE #{key} = #{val}")
        end
        result
      end

      def table_name
        self.name.downcase + 's'
      end

      def db_name
        Config[:root] + Config[:db_path] + Config[:db_name]
      end
    end
  end

  # model migration
  class Migration
    def initialize
      @column = {}
    end

    def connect(dbname = 'default')
      raise TypeException unless dbname.is_a?(String)
      @db = SQLite3::Database.new(Config[:root] + Config[:db_path] + dbname)
    end

    def disconnect
      @db.close
    end

    def create_table(table_name, &block)
      yield(self)
      connect
      @db.exec(parser(table_name))
      disconnect
    end

    def string(name, *opt)
      create_line(name, opt, 'varchar(255)')
    end

    def text(name, *opt)
      create_line(name, opt, 'text')
    end

    def integer(name, *opt)
      create_line(name, opt, 'integer')
    end

    def decimal(name, *opt)
      create_line(name, opt, 'decimal(10,5)')
    end

    def boolean(name, *opt)
      create_line(name, opt, 'boolean')
    end

    def create_line(name, opt, type)
      suffix = ''
      if opt.first.is_a?(Hash)
        opt = opt.first
        # raise TypeError, '' if opt.is_a(Hash)
        opt.each do |k, v|
          if k.to_s == 'default'
            v = "'#{v}'" if v.is_a?(String)
            suffix += " #{k} #{v}"
          elsif k == :null && !v
            suffix += ' not null'
          elsif k == :primary && v
            suffix += ' primary key'
          end
        end
      elsif !opt.empty?
        raise TypeError, 'specify constraints with Hash'
      end
      suffix += ','
      @column[name] = type + suffix
    end

    def parser(table_name)
      sql = "create table #{table_name}("
      @column.each do |k, v|
        sql += ' ' unless sql[-1] == '('
        sql += "#{k} #{v}"
      end
      sql = sql.chop + ')'
      sql
    end
  end
end
