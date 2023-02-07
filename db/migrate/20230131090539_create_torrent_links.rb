class CreateTorrentLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :torrent_links do |t|
      t.belongs_to :search, foreign_key: true
      t.string :name
      t.string :link
      t.string :link_forum
      t.integer :seeds, default: 0
      t.integer :lychee, default: 0
      t.string :hd, default: "0"

      t.timestamps
    end
  end
end
