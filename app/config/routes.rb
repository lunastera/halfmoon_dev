
$mapping = [
  ['',      'app/controller/debug:TestApp#index'],
  ['/api', [
    ['',    'app/controller/debug:TestApp#index'],
    ['/test', [
      ['',          'app/controller/debug:TestApp#index'],
      ['/:id',      'app/controller/debug:TestApp#show'],
      ['/:id/edit', 'app/controller/debug:TestApp#edit'],
      ['/:name/:id', 'app/controller/debug:TestApp#show']
    ]]
  ]],
  ['/user', [
    ['',    'app/controller/login:Login#index'],
    ['/login', [
      ['',          'app/controller/login:Login#login'],
      ['/:id',      'app/controller/login:Login#index']
    ]]
  ]]
]
