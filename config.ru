
require_relative './luna.rb'
require_relative './luna/routes.rb'

use Rack::Static, urls: ['/assets'], root: 'app'
# run CommonLogger.new(ShowExceptions.new(Luna::Luna.new))
app = Luna::Application.new($mapping)
run app
