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
require './app/models/comment'
require './app/models/edit_rights'

require './app/repositories/user_repository'
require './app/repositories/promise_repository'
require './app/repositories/comment_repository'

require './app/services/file_service'
require './app/services/file_streamer'

require './app/controllers/user_controller'
require './app/controllers/login_controller'
require './app/controllers/comment_controller'
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
              '/showPromise' => 'promise#single',
              '/comments' => 'comment#comments',
              '/promiseRights' => 'promise#promise_rights',
              '/getPromise' => 'promise#single_json',
              '/getUsers' => 'user#all',
              '/confirmPromise' => 'promise#confirm'
          },
          post: {
            '/register' => 'user#register',
            '/login' => 'login#login',
            '/upload' => 'upload#upload',
            '/createPromise' => 'promise#create',
            '/comment' => 'comment#comment',
            '/updatePromise' => 'promise#update',
            '/editPromise' => 'promise#edit'
          },
      }

use Rack::Static, :urls => ["/css", "/images", "/uploads", "/js"], :root => "app/public"
use Rack::Session::Pool

controller_registry = Guac::ControllerRegistry.new
controller_registry.add_controllers('user' => Guac::UserController.new(),
                                   'login' => Guac::LoginController.new(),
                                   'upload' => Guac::UploadController.new(),
                                   'promise' => Guac::PromiseController.new(),
                                   'comment' => Guac::CommentController.new())
router = Guac::Router.new controller_registry, ROUTES

sessioned = Rack::Session::Pool.new(router,
  #:domain => '0.0.0.0',
  :expire_after => 2592000
)

run sessioned
