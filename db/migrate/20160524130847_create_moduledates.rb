class CreateModuledates < ActiveRecord::Migration
  def change
    create_table :moduledates do |t|
      t.text :name
      t.date :opendate
      t.date :closedate

      t.timestamps
    end
  end
end
