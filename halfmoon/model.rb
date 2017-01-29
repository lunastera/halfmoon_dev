module Model
  # model base
  class Base
    class << self
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

    def initialize
      @column_order = []
      this = self.class.name
      klass_name = this + 'Migration'
      load Config[:root] + Config[:db_path] + "migration/#{this}_migration.rb"
      klass = Kernel.const_get(klass_name).new
      klass.change
      create_variables(klass)
    end

    def save
      table_name = self.table_name
      values = ''
      column = ''
      @column_order.each do |c|
        next if (v = eval("@#{c}")).nil?
        column << c
        v = "'#{v}'" if v.is_a?(String)
        values << v
      end
      column = "(#{column.join(', ')})" unless column.length.zero?
      values = "(#{values.join(', ')})"
      sql = "insert into #{table_name}#{column} values#{values}"
      SQLite3::Database.new(Config[:root] + Config[:db_path] + Config[:db_name]) do |db|
        db.exec(sql)
      end
    end

    # TODO: update
    # def update
    #   table_name = self.table_name
    #
    #   @column_order.each do |c|
    #     next if (v = eval("@#{c}")).nil?
    #     column << c
    #     v = "'#{v}'" if v.is_a?(String)
    #     values << v
    #   end
    #   sql = "update #{table_name} set "
    # end

    private

    def create_variables(klass)
      params = klass.instance_variable_get(:@column)
      params.each do |k, _|
        @column_order << k
        singleton_class.class_eval { attr_accessor k }
      end
    end
  end

  # model migration
  class Migration
    def initialize
      @column = {}
    end

    def create_table(table_name, &_)
      yield(self)
      @table_name = table_name
    end

    def save
      SQLite3::Database.new(Config[:root] + Config[:db_path] + Config[:db_name]) do |db|
        db.exec(parser(@table_name))
      end
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
