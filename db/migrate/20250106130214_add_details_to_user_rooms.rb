class AddDetailsToUserRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :user_rooms, :user_id, :integer
    add_column :user_rooms, :room_id, :integer
  end
end
