class AddStudentsTable < ActiveRecord::Migration
  def change
    create_table :students, :force => true do |t|
      t.string :first_name
      t.string :last_name
      t.string :sid_number
    end
  end
end
