
require 'rack'
require 'erb'
require 'sqlite3'

# other
require 'halfmoon/exception'
require 'halfmoon/util'
require 'halfmoon/route'
require 'halfmoon/action'

module HalfMoon
  # Action matched Class
  class ActionMatching
    # @params [Hash] action_args File: ファイルパス, Klass: クラス名, Action: 実行されるメソッド, PathV: パスパラメータ
    def initialize(action_args)
      @args = action_args
    end

    def response_action(req)
      require_relative @args[:File]

      ins = Kernel.const_get(@args[:Klass]).new(compile_params(req))
      # ins.before_action
      # file, type = ins.send(@args[:Action].to_sym)
      # ins.after_action
      ins.send(@args[:Action].to_sym)
    end

    def compile_params(req)
      get = req.GET
      post = req.POST
      { Paths: @args[:PathV], GET: get, POST: post, Session: req.session }
    end
  end

  # RackApplication
  class Application
    def initialize(mapping = nil)
      @route = Route.new(mapping)
    end

    def call(env)
      req = Rack::Request.new(env)
      args = @route.action_variables(req.path_info)
      if args[:File] == 404
        p args
        ex = ShowException.new(404)
        return ex.show
      end
      act_match = ActionMatching.new(args)
      res = act_match.response_action(req)
      res
    end

    # リクエストを捌く
    # def request_handler(req, res)
    #   req_method = HTTP_REQUEST_METHODS[req.request_method]
    #   if req_method == :HEAD
    #     req_method_ = :GET
    #   elsif req_method == :POST && /\A_method=(\w+)/.match(req.env['QUERY_STRING'])
    #     req_method_ = HTTP_REQUEST_METHODS[$1] || $1
    #   else
    #     req_method_ = req_method
    #   end
    # end
  end
end
