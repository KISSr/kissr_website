class RenameNameToDomainOnSites < ActiveRecord::Migration
  def up
    rename_column :sites, :name, :domain
    execute "UPDATE sites set domain = domain || '.kissr.com'"
  end

  def down
    rename_column :sites, :domain, :name
  end
end
