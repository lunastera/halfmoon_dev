
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'luna'
require 'app/config/routes'
require 'app/config/config'
require 'rack'

Config.add :root, File.expand_path(File.dirname(__FILE__))

# run CommonLogger.new(ShowExceptions.new(Luna::Luna.new))
app = Luna::Application.new($mapping)

require 'rack/session/cookie'
app = Rack::Session::Cookie.new(app, Config.get_all(/session_/))
# app = Rack::Static.new(app, {urls: [Config[:assets_dir]], root: Config[:assets_root]})
# useの方でなければurls:に配列を指定できない? 要検証
use Rack::Static, urls: Config[:assets_dir], root: Config[:assets_root]

run app
