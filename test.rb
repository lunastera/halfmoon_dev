def _compile_array(mapping, base_urlpath_pat, urlpath_pat)
  buf = []
  curr_urlpath_pat = "#{base_urlpath_pat}#{urlpath_pat}"
  mapping.each do |child_urlpath_pat, target|
    child = child_urlpath_pat
    #; [!w45ad] can compile nested array.
    if target.is_a?(Array)
      buf << _compile_array(target, curr_urlpath_pat, child)
    #; [!wd2eb] accepts subclass of Action class.
    elsif target.is_a?(Class) && target < Action
      buf << _compile_class(target, curr_urlpath_pat, child)
    #; [!l2kz5] requires library when filepath and classname specified.
    elsif target.is_a?(String)
      klass = _require_action_class(target)
      buf << _compile_class(klass,  curr_urlpath_pat, child)
    #; [!irt5g] raises TypeError when unknown object specified.
    else
      raise TypeError.new("Action class or nested array expected, but got #{target.inspect}")
    end
  end
  #; [!bcgc9] skips classes which have only fixed urlpaths.
  buf.compact!
  # rexp_str = _build_rexp_str(urlpath_pat, buf)
  return buf  # ex: '/api(?:/books/\d+(\z)|/authors/\d+(\z))'
end

def _compile_class(action_class, base_urlpath_pat, urlpath_pat)
  buf = []
  curr_urlpath_pat = "#{base_urlpath_pat}#{urlpath_pat}"
  action_class._action_method_mapping.each do |child_urlpath_pat, methods|
    #; [!ue766] raises error when action method is not defined in action class.
    _validate_action_method_existence(action_class, methods)
    #; ex: '/api/books/{id}' -> '\A/api/books/(\d+)\z', ['id'], [proc{|x| x.to_i}]
    fullpath_pat = "#{curr_urlpath_pat}#{child_urlpath_pat}"
    rexp_str, pnames, procs = _compile_urlpath_pat(fullpath_pat, true)
    #; [!z2iax] classifies urlpath contains any parameter as variable one.
    if pnames
      fullpath_rexp = Regexp.compile("\\A#{rexp_str}\\z")
      range = @enable_urlpath_param_range ? _range_of_urlpath_param(fullpath_pat) : nil
      tuple = [fullpath_pat, action_class, methods, fullpath_rexp, pnames.freeze, procs, range]
      @variable_endpoints << tuple
      buf << (_compile_urlpath_pat(child_urlpath_pat).first << '(\z)')
    #; [!rvdes] classifies urlpath contains no parameters as fixed one.
    else
      tuple = [fullpath_pat, action_class, methods]
      @fixed_endpoints[fullpath_pat] = tuple
    end
    #
    @all_endpoints << tuple
  end
  #; [!6xwhq] builds action infos for each action methods.
  action_class._build_action_info(curr_urlpath_pat) if action_class
  #
  rexp_str = _build_rexp_str(urlpath_pat, buf)
  return rexp_str    # ex: '/books(?:/\d+(\z)|/\d+/edit(\z))'
end

def _require_action_class(filepath_and_classname)
  #; [!px9jy] requires file and finds class object.
  str = filepath_and_classname   # ex: './admin/api/book:Admin::BookAPI'
  filepath, classname = filepath_and_classname.split(':', 2)
  begin
    require filepath
  rescue LoadError => ex
    #; [!dlcks] don't rescue LoadError when it is not related to argument.
    raise unless ex.path == filepath
    #; [!mngjz] raises error when failed to load file.
    raise LoadError.new("'#{str}': cannot load '#{filepath}'.")
  end
  #; [!8n6pf] class name may have module prefix name.
  #; [!6lv7l] raises error when action class not found.
  begin
    klass = classname.split('::').inject(Object) {|cls, x|  } # cls.const_get(x)
  rescue NameError
    raise NameError.new("'#{str}': class not found (#{classname}).")
  end
  #; [!thf7t] raises TypeError when not a class.
  klass.is_a?(Class)  or
    raise TypeError.new("'#{str}': class name expected but got #{klass.inspect}.")
  #; [!yqcgx] raises TypeError when not a subclass of K8::Action.
  # klass < Action  or
  #   raise TypeError.new("'#{str}': expected subclass of K8::Action but not.")
  #
  return klass
end

mapping = [
  ['/'                             , "./app/page/welcome:WelcomePage"],
  ['/api', [
    ['/hello'                      , "./app/api/hello:HelloAPI"],
   #['/books'                      , "./app/api/books:BooksAPI"],
   #['/books/{book_id}/comments'   , "./app/api/books:BookCommentsAPI"],
   #['/orders'                     , "./app/api/orders:OrdersAPI"],
  ]],
  ['/admin', [
   #['/books'                      , "./app/admin/books:AdminBooksPage"],
   #['/orders'                     , "./app/admin/orders:AdminOrdersPage"],
  ]],
  ['/static'                       , "./app/action:My::StaticPage"],
]

_compile_array(mapping, '', '')
