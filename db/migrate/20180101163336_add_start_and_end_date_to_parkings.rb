# frozen_string_literal: true

# rubocop:disable Rails/ReversibleMigration
# rubocop:disable Rails/BulkChangeTable

class AddStartAndEndDateToParkings < ActiveRecord::Migration[5.1]
  def change
    add_column :parkings, :start_date, :date
    add_column :parkings, :end_date, :date
    remove_column :parkings, :nights
  end
end

# rubocop:enable Rails/ReversibleMigration
# rubocop:enable Rails/BulkChangeTable
