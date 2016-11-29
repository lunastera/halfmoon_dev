
require_relative '../action.rb'

# TestController
class TestApp < Action
  def index
    @action = { Class: fullname, Method: __method__ }
    render(:html, 'debug')
  end

  def show
    @action = { Class: fullname, Method: __method__ }
    render(:html, 'debug')
  end

  def edit
    @action = { Class: fullname, Method: __method__ }
    render(:html, 'debug')
  end

  def fullname
    self.class.to_s
  end
end
