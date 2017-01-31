# TestController
class DebugController < Action
  def initialize(params)
    super(params)
    @users = User.all
  end

  def index
    @action = { Class: fullname, Method: __method__ }
    session[:hoge] = 'Session格納確認' if session[:hoge].nil?
    render(:html, 'debug/debug')
  end

  def show
    @action = { Class: fullname, Method: __method__ }
    redirect_to('/debug')
    # render(:html, 'debug')
  end

  def edit
    @action = { Class: fullname, Method: __method__ }
    render(:html, 'debug/debug')
  end

  def fullname
    self.class.to_s
  end
end
