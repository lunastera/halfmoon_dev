require_relative 'base'
# Main config
class Config < ConfigBase
  # app setting
  add :serv_port,   '8282'

  # database settings
  add :dbhost,      'localhost'
  add :dbport,      '8888'
  add :dbuser,      'root'
  add :dbpass,      'root'

  # path setting
  add :ctrl_path,   './app/controller'
  add :def_act,     'index'
  add :assets_dir,  '/assets'
  add :assets_root, 'app'
end
