=begin
A toy Sinatra app to demonstrate the basic concept of MVC, RESTful Routes and CRUD.
Run ``bundle install`` to make sure you have necessary gems installed.
TO run the script, type ``ruby final.rb`` in command line.
updated: jeremy warner, original author: hezheng.yin
=end

# load libraries we need
require 'sinatra'
require 'active_record'
require 'json'

# tell active_record which database to connect to
db_options = {adapter: 'sqlite3', database: 'todos_db'}
ActiveRecord::Base.establish_connection(db_options)

# write migration class for creating Todo table in database
### how do we write migration in rails?
class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.string :description
    end
  end
end

# create Todo table by executing the function we just wrote
### how do apply migration in rails?
### why do we handle exception here?
begin
  CreateTodos.new.change
rescue ActiveRecord::StatementInvalid
  # it's probably OK
end

# create Todo class by inheriting from ActiveRecord::Base
### how do we write new class in Rails?
### why there's no setter and getter method (or attr_accessor)?
class Todo < ActiveRecord::Base
  validates :description, presence: true, allow_blank: false
end

# populate the database if it is empty (avoid running this piece of code twice)
### do you still remember this cleaner and simpler hash syntax?
if Todo.all.empty?
  Todo.create(description: "prepare for discussion section")
  Todo.create(description: "release cs169 hw3")
end

# display all todos
get '/todos' do
  content_type :json
  Todo.all.to_json
end

# show a specific todo
get '/todos/:id' do
  content_type :json
  todo = Todo.find_by_id(params[:id])
  if todo
    return {description: todo.description}.to_json
  else
    return {msg: "error: specified todo not found"}.to_json
  end
end

# create a new todo
# goal: if we receive non-empty description, render json with msg set to "create success"
# 			otherwise render json with msg set to "error: description can't be blank"
post '/todos' do
  content_type :json
  todo = Todo.new(description: params[:description])
  if todo.save
    return {msg: "create success"}.to_json
  else
    return {msg: todo.errors}.to_json
  end
end

# update a todo
# return: if todo with specified id exist and description non-empty, render json with msg set to "update success"
# 				otherwise render json with msg set to "update failure"
put '/todos/:id' do
  content_type :json
  todo = Todo.find(params[:id])
  if todo.update_attribute(:description, params[:description])
    return {msg: "update success"}.to_json
  else
    return {msg: todo.errors}.to_json
  end
end

# delete a todo
# return: if todo with specified id exist, render json with msg set to "delete success"
# 				otherwise render json with msg set to "delete failure"
delete '/todos/:id' do
  content_type :json
  todo = Todo.find(params[:id])
  if todo
    todo.destroy
    return {msg: "delete success"}.to_json
  else
    return {msg: "delete failure"}.to_json
  end
end
