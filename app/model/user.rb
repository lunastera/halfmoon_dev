class User < Model::Base
  attr_accessor :name, :age

  def initialize(*args)
    # if args.length != 2
    #   @name = 'テスト太郎'
    #   @age  = 24
    # else
    #   @name = args[0]
    #   @age  = args[1]
    # end
  end

  def tes_mes
    'モデルからのアクセステストだよ'
  end
end
