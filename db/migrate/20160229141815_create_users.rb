class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :netid
      t.integer :module_id
      t.integer :module_id
      t.string :module

      t.timestamps
    end
  end
end
