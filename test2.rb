class WelcomePage
  TEST = 'TEST'.freeze

  def hoge
    p 'hoge'
  end
end

wel = Kernel.const_get('WelcomePage').new
wel.hoge

# WelcomePage.hoge

__END__

filepath_and_classname = './app/page/welcome:WelcomePage::'

filepath, classname = filepath_and_classname.split(':', 2)

klass = classname.split('::').inject(Object) { |kls, x| kls.const_get(x) }

klass.is_a?(Class)  or raise TypeError.new("'#{str}': class name expected but got #{klass.inspect}.")

puts klass
