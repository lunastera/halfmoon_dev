class Login < Action
  def before_action
    @auth = Auth.new(@session)
  end

  def index
    if @auth.is_login?

    end
    render(:html, 'index')
  end

  def login
    render(:html, 'login')
  end

  def fullname
    self.class.to_s
  end
end
