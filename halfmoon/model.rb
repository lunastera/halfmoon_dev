module Model
  # model base
  class Base
    class << self
      # 現状SQLiteのみ 後から他のデータベースにも対応
      def all
        @db.execute('SELECT * FROM ' + name)
      end
    end
  end

  # model migration
  class Migration
    def initialize
      @column = {}
    end

    def create_table(table_name, &block)
      yield(self)
      parser

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
          end
        end
      elsif !opt.empty?
        raise TypeError, 'specify constraints with Hash'
      end
      suffix += ','
      @column[name] = type + suffix
    end

    def parser
      sql = 'create table user('
      @column.each do |k, v|
        sql += ' ' unless sql[-1] == '('
        sql += "#{k} #{v}"
      end
      sql = sql.chop + ')'
      sql
    end

    def create(dbname = 'default')
      raise TypeException unless dbname.is_a?(String)
      @db = SQLite3::Database.new(Config[:root] + Config[:db_path] + '/db/' + dbname)
      @db.exec(parser)
    end
  end
end
