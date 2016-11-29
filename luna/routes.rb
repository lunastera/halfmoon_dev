
$mapping = [
  ['',      './app/controller/index:TestApp#index'],
  ['/api', [
    ['',    './app/controller/index:TestApp#index'],
    ['/test', [
      ['',          './app/controller/index:TestApp#index'],
      ['/:id',      './app/controller/index:TestApp#show'],
      ['/:id/edit', './app/controller/index:TestApp#edit'],
      ['/:name/:id', './app/controller/index:TestApp#show']
    ]]
  ]],
  ['/user', [
    ['',    './app/controller/login:Login#index'],
    ['/login', [
      ['',          './app/controller/login:Login#login'],
      ['/:id',      './app/controller/login:Login#index']
    ]]
  ]]
]
