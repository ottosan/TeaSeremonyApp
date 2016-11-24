class AddImgToContributions < ActiveRecord::Migration
  def change
  	add_column :contributions, :img, :string
  end
end
