class User
  attr_reader :id
  attr_accessor :todo

  def initialize
    @id = app.get_new_user_id
    @todo = Todo.new
  end
end

class Todo
  def initialize
    @items = Array.new
  end

  def add item
    if not @items.include? item
      @items << item
    end
  end

  def delete item
    @items.delete item
  end

  def view_item item_id
    # assume each item instance has an accessible id field,
    # and all items/ids are unique
    item = @item.find {|i| i.id = item_id } # SOLUTION
    format_as_json item unless item.nil?
  end
end

# Route Handling (Sinatra)

# The below code is commented out because it will not run unless in Sinatra
# Feel free to uncomment by removing "=begin" and "=end"

=begin
get '/user/:id/todo' do
  user = get_user_by_id params[:id]
  user.todo.to_json # SOLUTION
end

get '/user/:id/todo/:item_id' do
  user = get_user_by_id params[:id]
  todo = user.todo # SOLUTION
  todo.view_item params[:item_id] # SOLUTION
end

post '/user/:id/todo' do
  user = get_user_by_id params[:id]
  request.body.rewind
  raw_item = JSON.parse request.body.read
  user.todo.add raw_item # SOLUTION
  201 # SOLUTION (Return 201 to indicate resource created)
end

delete '/user/:id/todo/:item' do
  user = get_user_by_id params[:id]
  user.todo.delete params[:item] # SOLUTION
  200 # SOLUTION (Return 200 to indicate resource deleted)
end
=end
