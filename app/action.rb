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

  def render(type, file)
    current = File.expand_path(File.dirname(__FILE__))
    ERB.new(
      File.open(current + '/view/' + file + '.' + type.to_s + '.erb').read
    ).result(binding)
    # return file, mime_type
  end
end
