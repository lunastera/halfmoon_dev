
require 'rack'

# other
require_relative './luna/exception'
require_relative './luna/util'
require_relative './luna/route'

module Luna
  # Action matched Class
  class ActionMatching
    # params
    # action_args =>
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

      # ERB.new(File.open(File.expand_path(
      #   File.dirname(__FILE__)) + '/app/view/' + file + '.' + type.to_s + '.erb'
      # ).read).result(ins.bind)
    end

    protected

    def compile_params(req)
      get = req.GET
      post = req.POST
      { Paths: @args[:PathV], GET: get, POST: post }
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
      body = act_match.response_action(req)
      [200, { 'Content-Type' => 'text/html' }, [body]]
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
