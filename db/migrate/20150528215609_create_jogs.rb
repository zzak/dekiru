class CreateJogs < ActiveRecord::Migration
  def change
    create_table :jogs do |t|
      t.integer :n
      t.jsonb :results, null: false, default: '{}'

      t.timestamps
    end
  end
end
