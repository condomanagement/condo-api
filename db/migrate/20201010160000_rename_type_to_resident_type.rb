# frozen_string_literal: true

# rubocop:disable Rails/ReversibleMigration

class RenameTypeToResidentType < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :type, :resident_type
    change_column_default :users, :resident_type, "none"
  end
end

# rubocop:enable Rails/ReversibleMigration
