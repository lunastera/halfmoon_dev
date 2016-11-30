#\ --port 8282

require_relative './luna.rb'
require_relative './luna/config/routes.rb'
require_relative './luna/config/config.rb'

use Rack::Static, urls: [Config[:assets_dir]], root: Config[:assets_root]
# run CommonLogger.new(ShowExceptions.new(Luna::Luna.new))
app = Luna::Application.new($mapping)
run app
