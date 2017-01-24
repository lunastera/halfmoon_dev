class Login < Action
  def index
    render(:html, 'index')
  end

  def login
    unless @post[:id].nil?
      user = User.find_by(id: @post[:id])
      if HalfMoon::Auth.password(@post[:id], @post[:pass]) == user.pass
        @session[:user] = user
        redirect_to()
      end
    end
    render(:html, 'login')
  end

  def fullname
    self.class.to_s
  end
end
