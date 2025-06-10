class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :position
      t.date :joined_date

      t.timestamps
    end
  end
end
