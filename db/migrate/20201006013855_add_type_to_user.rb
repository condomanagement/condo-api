# frozen_string_literal: true

class AddTypeToUser < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE user_type AS ENUM ('tenant', 'owner', 'none');
      ALTER TABLE users ADD type user_type;
    SQL
  end

  def down
    execute <<-SQL
      DROP TYPE user_type;
    SQL
    remove_column :type
  end
end
