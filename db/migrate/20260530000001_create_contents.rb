class CreateContents < ActiveRecord::Migration[8.1]
  def change
    create_table :contents do |t|
      t.string  :title, null: false
      t.text    :body
      t.boolean :is_favarite, null: false, default: false

      t.timestamps
    end
  end
end
