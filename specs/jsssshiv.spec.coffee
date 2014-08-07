describe 'JSSS Shiv', ->
  # fixtures
  container = undefined

  beforeEach ->
    JSSSShiv.install()
    container = document.createElement "div"
    document.body.appendChild container

  afterEach ->
    JSSSShiv.uninstall()
    container.parentElement.removeChild container

  # helper functions
  givenHTML = (html) ->
    container.innerHTML = html

  getCSS = (id, prop) ->
    e = document.getElementById id
    getComputedStyle(e).getPropertyValue prop

  describe 'supports a variety of tags', ->
    # <body>, <html>, and table-related tags have been removed from this list
    tagNames = ['a', 'abbr', 'address', 'area', 'article', 'aside', 'audio', 'b', 'base', 'bdi', 'bdo', 'blockquote', 'br', 'button', 'canvas', 'cite', 'code', 'data', 'datalist', 'dd', 'del', 'details', 'dfn', 'div', 'dl', 'dt', 'em', 'embed', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'header', 'hr', 'i', 'iframe', 'img', 'input', 'ins', 'kbd', 'keygen', 'label', 'legend', 'li', 'link', 'main', 'map', 'mark', 'math', 'menu', 'menuitem', 'meta', 'meter', 'nav', 'noscript', 'object', 'ol', 'optgroup', 'option', 'output', 'p', 'param', 'pre', 'progress', 'q', 'rp', 'rt', 'ruby', 's', 'samp', 'script', 'section', 'select', 'small', 'source', 'span', 'strong', 'style', 'sub', 'summary', 'sup', 'svg', 'table', 'template', 'textarea', 'time', 'title', 'track', 'u', 'ul', 'var', 'video', 'wbr']
    for tagName in tagNames
      do(tagName) ->
        it tagName, ->
          givenHTML  "<#{tagName} id=\"a\">Foo</#{tagName}>"
          document.tags[tagName].color = "blue"
          expect(getCSS 'a', 'color').toBe  'rgb(0, 0, 255)'

  it 'allows capitalized tags', ->
    givenHTML  '<h1 id="a">Foo</h1>'
    document.tags.H1.color = "blue"
    expect(getCSS 'a', 'color').toBe  'rgb(0, 0, 255)'

  it 'multiple styles may be applied', ->
    givenHTML '<h1 id="a">Foo</h1>'
    document.tags.H1.color = "blue"
    document.tags.H1.bgColor = "red"
    expect(getCSS 'a', 'color').toBe  'rgb(0, 0, 255)'
    expect(getCSS 'a', 'background-color').toBe  'rgb(255, 0, 0)'

  it 'tag styles are inherited by children', ->
    givenHTML  '<h1 id="a">Foo</h1>'
    document.tags.BODY.color = "blue"
    expect(getCSS 'a', 'color').toBe  'rgb(0, 0, 255)'
