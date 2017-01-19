# 仕様書

## Req Res 書き置き

```ruby

 # リクエスト処理クラス
class Request
  attr_reader :env, :method

  def initialize(env)
    @env = env
    @method = HTTP_REQUEST_METHODS[env['REQUEST_METHOD']] or
      raise HTTPException.new(400, "#{env['REQUEST_METHOD'].inspect}: unknown request method.")
  end

  # rubocop:disable all
  def request_method  ; @env['REQUEST_METHOD']  || ''; end
  def server_name     ; @env['SERVER_NAME']          ; end
  def scheme          ; @env['rack.url_scheme']      ; end
  def http_host       ; @env['HTTP_HOST']            ; end
  alias host http_host
  def server_port     ; @env['SERVER_PORT'].to_i     ; end
  alias port server_port
  def path_info       ; @env['PATH_INFO']       || ''; end
  def script_name     ; @env['SCRIPT_NAME']     || ''; end
  def content_length  ; @env['CONTENT_LENGTH']       ; end
  def content_type    ; @env['CONTENT_TYPE']         ; end
  def query_string    ; @env['QUERY_STRING']    || ''; end

  def http_host       ; @env['HTTP_HOST']       || ''; end
  def http_cookie     ; @env['HTTP_COOKIE']     || ''; end
  def user_agent      ; @env['HTTP_USER_AGENT']      ; end

  def rack_input      ; @env['rack.input'].gets || ''; end
  alias body rack_input

  def referer        ; @env['HTTP_REFERER']     || ''; end
  alias referrer referer
  # rubocop:enable all

  def get
    Rack::Utils.parse_query(query_string) || {}
  end

  def post
    Rack::Request.POST
  end
end

 # レスポンス処理クラス
class Response
  attr_accessor :status_code
  attr_reader   :headers

  alias status status_code
  alias status= status_code=

  def initialize
    @status_code = 200
    @headers = {}
  end

  def content_type
    @headers['Content-Type']
  end

  def content_type=(content_type)
    @headers['Content-Type'] = content_type
  end
end

```


## 考えてること

1.
HalfMoonモジュールに全て突っ込むよりControllerで使うものは  
Actionクラスに定義した方がいいのでは・・・？

- Action::Auth
- Action::Util

Controller < Action

self::Auth.newとかできる

2.
ファイル名を書いたならクラス名の記述はいらないのでは？  
ルーティングが冗長になる
