class CreateBookingSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :booking_slots do |t|
      t.datetime :date
      t.datetime :from_time
      t.datetime :to_time
      t.integer :user_id
      t.string :name

      t.timestamps
    end
  end
end
