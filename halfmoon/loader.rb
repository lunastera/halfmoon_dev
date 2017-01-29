module HalfMoon
  module Loader
    def delay_require(path, root = Config[:root])
      path += '.rb' if path =~ /\.rb$/
      location = root + path
      require location
    end

    def hm_autoload(const_name, file)
      location = Config[:root] + file
      autoload const_name, location
    end

    def hm_load(file)
      location = Config[:root] + file + '.rb'
      load location
    end
  end
end
