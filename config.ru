# config.ru
require 'rack'
require 'erb'
require 'sqlite3'
require 'time'
require 'mime-types'


require './guac/controller/base_controller'
require './guac/controller_registry'
require './guac/router'

require './app/models/user'
require './app/models/promise'

require './app/repositories/user_repository'
require './app/repositories/promise_repository'

require './app/services/file_service'
require './app/services/file_streamer'

require './app/controllers/user_controller'
require './app/controllers/login_controller'
require './app/controllers/upload_controller'
require './app/controllers/promise_controller'

DB = SQLite3::Database.new './db/database.sqlite3'


ROUTES = {
          get: {
              '/' => 'user#show',
              '/show' => 'user#show',
              '/register' => 'user#register',
              '/login' => 'login#login',
              '/logout' => 'login#logout',
              '/upload' => 'upload#upload',
              '/download' => 'upload#download',
              '/createPromise' => 'promise#create',
              '/listPromises' => 'promise#list',
              '/showPromise' => 'promise#single'
          },
          post: {
            '/register' => 'user#register',
            '/login' => 'login#login',
            '/upload' => 'upload#upload',
            '/createPromise' => 'promise#create',
          },
      }

use Rack::Static, :urls => ["/css", "/images", "/uploads"], :root => "app/public"
use Rack::Session::Pool

controller_registry = Guac::ControllerRegistry.new
controller_registry.add_controllers('user' => Guac::UserController.new(),
                                   'login' => Guac::LoginController.new(),
                                   'upload' => Guac::UploadController.new(),
                                   'promise' => Guac::PromiseController.new())
router = Guac::Router.new controller_registry, ROUTES

sessioned = Rack::Session::Pool.new(router,
  #:domain => '0.0.0.0',
  :expire_after => 2592000
)

run sessioned
