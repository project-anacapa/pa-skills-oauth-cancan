class AddIsInstructorToUsers < ActiveRecord::Migration

  def up
    add_column :users, :is_instructor, :boolean, default: false, null: false
  end

  def down
    remove_column :users, :is_instructor
  end

end
