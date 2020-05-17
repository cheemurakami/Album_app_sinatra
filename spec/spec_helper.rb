require 'rspec'
require 'pg'
require 'album'
require 'song'
require 'pry'

#shared code for clearing tests between runs and connecting to the DB will also go here.

DB = PG.connect({:dbname => 'record_store_test'}) #hash

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM albums *;") #delete Album.clear 
    DB.exec("DELETE FROM songs *;") #delete Song.clear 
  end
end
