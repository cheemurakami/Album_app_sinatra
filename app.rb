require("sinatra")
require('sinatra/reloader')
also_reload('lib/**/*.rb')

get '/' do
  "Hello World"
end