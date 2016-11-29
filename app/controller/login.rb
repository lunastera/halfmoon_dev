
require_relative '../action'

class Login < Action
  def index(args = nil)
    @args = args
    @action = { Class: fullname, Method: __method__ }
    render(:html, 'debug')
  end

  def login(args = nil)
    @args = args
    @action = { Class: fullname, Method: __method__ }
    render(:html, 'login')
  end

  def fullname
    self.class.to_s
  end
end
