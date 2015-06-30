class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :key, index: true, unique: true
      t.datetime :expires_at

      t.timestamps null: false
    end
  end
end
