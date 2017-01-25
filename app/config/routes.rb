# 'URL', 'controller/method'
$mapping = [
  ['', 'debug/index'],
  ['/debug', [
    ['',           'debug/index'],
    ['/:id',       'debug/show'],
    ['/:id/edit',  'debug/edit'],
    ['/:name/:id', 'debug/show']
  ]],
  ['/users', [
    ['',           'users/index'],
    ['/index',     'users/index'],
    ['/show/:id',  'users/show']
  ]]
]
