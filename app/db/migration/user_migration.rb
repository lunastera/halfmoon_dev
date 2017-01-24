# Model Migration test
class User < Model::Migration
  def initialize
    create_table :users do |t|
      t.integer :id, null: false, primary: true
      t.string :name
      t.string :password
    end
  end
end
