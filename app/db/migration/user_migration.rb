# Model Migration test
class UserMigration < Model::Migration
  def change
    create_table :users do |t|
      t.integer :id, null: false, primary: true
      t.string :name
      t.string :password
    end
  end
end
