class MoreDetails < ActiveRecord::Migration
  def change
    add_column :competitions, :fb_page_url, :string
  end
end
