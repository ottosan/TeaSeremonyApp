class CreateContributions < ActiveRecord::Migration
  def change
  	create_table :contributions do |t|
  		t.string :title
  		t.string :body
  		t.timestamps null: false
  	end
  end
end
