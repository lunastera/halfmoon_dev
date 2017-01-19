require 'halfmoon/model'
# Action
class Action
  def initialize(params)
    @paths = params[:Paths]
    @get   = params[:GET]
    @post  = params[:POST]
    @session = params[:Session]
  end

  # 必ずアクション前に実行される処理
  def before_action
  end

  # 必ずアクション後に実行される処理
  def after_action
  end

  # このメソッドのbinding
  def bind
    binding
  end

  # @param [Symbol] model_name 使用するモデルの名前
  # @param [String, nil] file_name 使用するモデルのパス
  def self.use_model(model_name, file_name = nil)
    file_name = Config[:root] + Config[:model_path] + model_name.to_s.downcase if file_name.nil?
    autoload model_name, file_name
  end

  def session
    @session
  end

  protected

  def render(option, file)
    view_path = Config[:root] + Config[:view_path]
    ERB.new(
      File.open(view_path + file + '.erb').read
    ).result(binding)
    # return file, mime_type
  end

  def redirect_to(path)
    # TODO
  end
end
