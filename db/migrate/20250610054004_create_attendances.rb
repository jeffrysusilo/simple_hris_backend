class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :check_in
      t.datetime :check_out
      t.date :date

      t.timestamps
    end
  end
end
