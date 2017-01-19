class User < Model
  def initialize
    create :users do |t|
      t.string :name
      t.integer :id
    end
  end
end
