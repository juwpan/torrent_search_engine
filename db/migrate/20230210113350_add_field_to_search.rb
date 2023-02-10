class AddFieldToSearch < ActiveRecord::Migration[7.0]
  def change
    add_column :searches, :sort, :string, default: "0"
  end
end
