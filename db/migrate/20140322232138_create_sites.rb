class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.references :user, index: true
      t.string :domain

      t.timestamps
    end
  end
end
