class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text email
      t.access_token
      t.timestamps
    end
  end
end
