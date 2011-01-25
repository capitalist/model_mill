class CreateSomeTables < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, :null => false
      t.timestamps
    end

    create_table :widgets, :force => true do |t|
      t.integer :quantity, :default => 0
      t.string :color
      t.timestamps
    end
  end

  def self.down
    drop_table :widgets
    drop_table :users
  end
end
