# TestController
class TestApp < Action
  # Model：Userを使うことを宣言
  use_model :User

  def initialize(params)
    super(params)
    @user = User.new('testtarou', 24)
  end

  def index
    @action = { Class: fullname, Method: __method__ }
    session[:hoge] = 'Session格納確認' if session[:hoge].nil?
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
