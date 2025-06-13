class AddUserIdToEmployees < ActiveRecord::Migration[8.0]
  def change
    add_reference :employees, :user, null: false, foreign_key: true
  end
end
