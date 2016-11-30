require 'erb'

module Luna
  # エラーが起きた際に表示するページを生成するコード
  class ShowException
    def initialize(status_code)
      # @status_code = status_code
      @status = {}
      @status[:Code] = status_code
      @status[:Mes]  = HTTP_RESPONSE_STATUS[status_code]
    end

    def show
      current = File.expand_path(File.dirname(__FILE__))
      Dir.chdir(current)
      files = Dir.glob('*')
      if files.include?(@status[:Code].to_s + '.erb')
        body = ERB.new(
          File.open(current + '/' + @status[:Code].to_s + '.erb').read
        ).result(binding)
      else
        body = ERB.new(
          File.open(current + '/default.erb').read
        ).result(binding)
      end
      [@status[:Code], { 'Content-Type' => 'text/html' }, [body]]
    end
  end
end
