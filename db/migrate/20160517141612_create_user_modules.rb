class CreateUserModules < ActiveRecord::Migration
  def change
    create_table :user_modules do |t|
      t.string :netid
      t.integer :userid
      t.string :module
      t.integer :module_id

      t.timestamps
    end
  end
end
