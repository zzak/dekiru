class ChangeJogsNDefault < ActiveRecord::Migration
  def change
    change_column :jogs, :n, :integer, null: false, default: 0
  end
end
