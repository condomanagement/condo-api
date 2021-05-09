# frozen_string_literal: true

class ChangeElevatorBookingsApprovedToEnum < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE approved_type AS ENUM ('false', 'true', 'pending');
      ALTER TABLE elevator_bookings ADD status approved_type DEFAULT('pending');
    SQL
  end

  def down
    execute <<-SQL
      DROP TYPE approved_type;
    SQL
    remove_column :type
  end
end
