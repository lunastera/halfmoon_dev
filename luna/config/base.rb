
# __END__
# ConfigBaseClass
class ConfigBase
  def initialize
  end

  class << self
    def all
      @opts ||= {}
    end

    def add(key, val)
      class_ins = all
      class_ins[key] = val
      nil
    end

    def get(key)
      class_ins = all
      class_ins[key]
    end

    def to_a
      class_ins = all
      class_ins.to_a
    end

    def size
      class_ins = all
      class_ins.size
    end

    def each(&_block)
      ary = to_a
      size.times do |i|
        yield ary[i].first, ary[i].last
      end
    end
  end
end

# Main config
class Config < ConfigBase
  # database settings
  add :dbaddress,   'localhost'
  add :dbport,      '8888'
  add :dbuser,      'root'
  add :dbpass,      'root'

  # path setting
  add :ctrl_path,   './app/controller'
  add :def_act,     'index'
  add :assets_dir,  'assets'
  add :assets_root, 'app'
end

Config.new

p Config.get :dbaddress
