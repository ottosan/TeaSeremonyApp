class CreatePasswords < ActiveRecord::Migration
  def change
  	  	create_table :passwords do |t|
  		t.string :manager_password
  		t.string :user_password
  		t.timestamps null: false
  	end
  end
end
