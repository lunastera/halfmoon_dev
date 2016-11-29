# Action
class Action
  # params
  # params: Hash,
  def initialize(params)
    @paths = params[:Paths]
    @get   = params[:GET]
    @post  = params[:POST]
  end

  # 必ずアクション前に実行される処理
  def before_action
    puts 'before-action'
  end

  # 必ずアクション後に実行される処理
  def after_action
    puts 'after-action'
  end

  # このメソッドのbinding
  def bind
    binding
  end

  protected

  def render(mime_type, file)
    return file, mime_type
  end
end
