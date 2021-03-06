window.JSSSShiv = class JSSSShiv
  # https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/HTML5/HTML5_element_list
  @tagNames = ['a', 'abbr', 'address', 'area', 'article', 'aside', 'audio', 'b', 'base', 'bdi', 'bdo', 'blockquote', 'body', 'br', 'button', 'canvas', 'caption', 'cite', 'code', 'col', 'colgroup', 'data', 'datalist', 'dd', 'del', 'details', 'dfn', 'div', 'dl', 'dt', 'em', 'embed', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'header', 'hr', 'html', 'i', 'iframe', 'img', 'input', 'ins', 'kbd', 'keygen', 'label', 'legend', 'li', 'link', 'main', 'map', 'mark', 'math', 'menu', 'menuitem', 'meta', 'meter', 'nav', 'noscript', 'object', 'ol', 'optgroup', 'option', 'output', 'p', 'param', 'pre', 'progress', 'q', 'rp', 'rt', 'ruby', 's', 'samp', 'script', 'section', 'select', 'small', 'source', 'span', 'strong', 'style', 'sub', 'summary', 'sup', 'svg', 'table', 'tbody', 'td', 'template', 'textarea', 'tfoot', 'th', 'thead', 'time', 'title', 'tr', 'track', 'u', 'ul', 'var', 'video', 'wbr']

  @clear = =>
    if @style? then @style.innerHTML = ''

  # evaluate the passed-in function as a JS stylesheet
  @eval = (fn) =>
    @_install (@_identifiers fn.toString())
    fn()

  @run = =>
    # style tags
    for style in document.getElementsByTagName 'style' when (/javascript/i).test style.type
      fn = new Function [], style.innerHTML
      @eval fn

    # style attributes
    for elem in document.getElementsByTagName '*' when elem.hasAttribute 'style'
      @_apply elem, (elem.getAttribute 'style')

  @contextual = =>
    selector = (thing.selector for thing in arguments).join ' '
    new JSSSThing(selector, @style)

  # create the properties under document and global function; passed-in
  # identifiers will be added to the classes and ids objects
  @_install = (identifiers) =>
    # create CSS <style> tag to hold translated styles
    if !@style?
      @style = document.createElement 'style'
      @style.id = 'jsss-shiv-styles'
      document.body.appendChild @style

    # global function
    if !window.contextual?
      window.contextual = @contextual

    # populate document.tags with JSSSTag objects
    if !document.tags?
      document.tags = {}
      for tagName in @tagNames
        tag = new JSSSTag tagName, @style
        document.tags[tagName] = tag
        document.tags[tagName.toUpperCase()] = tag

    # populate document.classes with JSSSClass objects
    if !document.classes?
      document.classes = {}
    for ident in identifiers
      if !document.classes[ident]?
        document.classes[ident] = new JSSSClass ident, @style

    # populate document.ids with JSSSId objects
    if !document.ids?
      document.ids = {}
    for ident in identifiers
      if !document.ids[ident]?
        document.ids[ident] = new JSSSId ident, @style

    # bad implicit return is bad
    undefined

  # applies style to element, where style is a string to be compiled and executed
  @_apply = (elem, style) =>
    argumentNames = []
    argumentValues = []
    argumentFunctions = []
    cssRules = []
    defineProperty = (name, fn) ->
      argumentNames.push name
      argumentValues.push undefined
      argumentFunctions.push (newValue) ->
        cssRules.push fn(newValue)
    defineMethod = (name, fn) ->
      argumentNames.push name
      argumentValues.push ->
        cssRules.push fn.apply(null, arguments)
      argumentFunctions.push ->
    stylings defineProperty, defineMethod
    # enclose in a try catch block so errant styles don't kill everything
    try
      styleFn = new Function argumentNames, "#{style};return arguments;"
      newValues = styleFn.apply(null, argumentValues)
      for nv,idx in newValues when nv != undefined
        argumentFunctions[idx](nv)
      elem.setAttribute 'style', (cssRules.join ';')
    catch error
      undefined

  # pull out everything that looks like an id or class-name from the
  # passed-in text
  @_identifiers = (text) =>
    idents = []
    re = /[\w\-]+/g
    while (match = re.exec(text))
      idents.push match[0]
    idents

class JSSSThing
  constructor: (@selector, @styleElement, pseudoElements=true)->
    stylings @defineProperty, @defineMethod
    # 2.0 Typographical Elements (pseudo-elements)
    if pseudoElements
      @firstLine = new JSSSThing "#{@selector}:first-line", @styleElement, false
      @firstLetter = new JSSSThing "#{@selector}:first-letter", @styleElement, false

  defineProperty: (name, fn) =>
    Object.defineProperty this, name,
      set: (newValue) =>
        rule = fn(newValue)
        @styleElement.innerHTML += "#{@selector} {#{rule};}"

  defineMethod: (name, fn) =>
    this[name] = =>
      rule = fn.apply(null, arguments)
      @styleElement.innerHTML += "#{@selector} {#{rule};}"

class JSSSTag extends JSSSThing
  constructor: (tagName, style) ->
    super "#{tagName}", style

class JSSSClass
  constructor: (className, style) ->
    for tagName in JSSSShiv.tagNames
      this[tagName] = new JSSSThing "#{tagName}.#{className}", style
      this[tagName.toUpperCase()] = new JSSSThing "#{tagName}.#{className}", style
    this.all = new JSSSThing ".#{className}", style

class JSSSId extends JSSSThing
  constructor: (id, style) ->
    super "##{id}", style

stylings = (defineProperty, defineMethod) ->
  # 6.2 Font Properties
  defineProperty 'fontSize', (value) -> "font-size: #{value}"
  defineProperty 'fontStyle', (value) ->
    if value == 'small-caps'
      "font-variant: small-caps"
    else
      "font-style: #{value}"
  defineProperty 'lineHeight', (value) -> "line-height: #{value}"

  # 6.3 Color and Background Properties
  defineProperty 'color', (value) -> "color: #{value}"
  defineProperty 'background', (value) -> "background-image: url(#{value})"
  defineProperty 'bgColor', (value) -> "background-color: #{value}"

  # 6.4 Text Properties
  defineProperty 'wordSpacing', (value) -> "word-spacing: #{value}"
  defineProperty 'letterSpacing', (value) -> "letter-spacing: #{value}"
  defineProperty 'textDecoration', (value) -> "text-decoration: #{value}"
  defineProperty 'verticalAlign', (value) -> "vertical-align: #{value}"
  defineProperty 'textTransform', (value) -> "text-transform: #{value}"
  defineProperty 'textAlign', (value) -> "text-align: #{value}"
  defineProperty 'textIndent', (value) -> "text-indent: #{value}"

  # 6.5 Box Properties
  for side in ['left', 'right', 'top', 'bottom']
    do(side) =>
      defineProperty "#{side}Margin", (value) -> "margin-#{side}: #{value}"
      defineProperty "#{side}Padding", (value) -> "padding-#{side}: #{value}"
  defineMethod 'margins', (top, right, bottom, left) ->
    "margin: #{top} #{right} #{bottom} #{left}"
  defineMethod 'paddings', (top, right, bottom, left) ->
    "padding: #{top} #{right} #{bottom} #{left}"
  defineProperty 'borderStyle', (value) -> "border-style: #{value}"
  defineProperty 'borderWidth', (value) -> "border-width: #{value}"
  defineProperty 'width', (value) -> "width: #{value}"
  defineProperty 'height', (value) -> "height: #{value}"
  defineProperty 'float', (value) -> "float: #{value}"
  defineProperty 'clear', (value) -> "clear: #{value}"

  # 6.6 Classification Properties
  defineProperty 'display', (value) -> "display: #{value}"
  defineProperty 'listStyle', (value) -> "list-style: #{value}"
  defineProperty 'whiteSpace', (value) -> "white-space: #{value}"

document.addEventListener "DOMContentLoaded", JSSSShiv.run
