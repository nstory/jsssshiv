describe 'JSSS Shiv', ->
  # fixtures
  container = undefined

  beforeEach ->
    container = document.createElement "div"
    document.body.appendChild container

  afterEach ->
    JSSSShiv.clear()
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
          JSSSShiv.eval ->
            document.tags[tagName].color = "blue"
          expect(getCSS 'a', 'color').toBe  'rgb(0, 0, 255)'

  describe 'supports a variety of stylings', ->
    examples = [
      ['color', 'blue', 'color', 'rgb(0, 0, 255)']
      ['bgColor', 'blue', 'background-color', 'rgb(0, 0, 255)']
      ['fontSize', '42px', 'font-size', '42px']
      ['fontStyle', 'normal', 'font-style', 'normal']
      ['fontStyle', 'italic', 'font-style', 'italic']
      ['fontStyle', 'oblique', 'font-style', 'italic']
      ['fontStyle', 'small-caps', 'font-variant', 'small-caps']
      ['lineHeight', '42px', 'line-height', '42px']
      ['background', 'http://localhost/foobar.png', 'background-image', 'url(http://localhost/foobar.png)']
      ['wordSpacing', '4px', 'word-spacing', '4px']
      ['letterSpacing', '4px', 'letter-spacing', '4px']
      ['textDecoration', 'underline', 'text-decoration', 'underline']
      ['verticalAlign', 'text-top', 'vertical-align', 'text-top']
      ['textTransform', 'uppercase', 'text-transform', 'uppercase']
      ['textAlign', 'center', 'text-align', 'center']
      ['textIndent', '42px', 'text-indent', '42px']
      ['leftMargin', '42px', 'margin-left', '42px']
      ['rightMargin', '42px', 'margin-right', '42px']
      ['topMargin', '42px', 'margin-top', '42px']
      ['bottomMargin', '42px', 'margin-bottom', '42px']
      [((tag) -> tag.margins('1px', '2px', '3px', '4px')), 'margin-left', '4px']
      ['leftPadding', '42px', 'padding-left', '42px']
      ['rightPadding', '42px', 'padding-right', '42px']
      ['topPadding', '42px', 'padding-top', '42px']
      ['bottomPadding', '42px', 'padding-bottom', '42px']
      ['borderStyle', 'solid', 'border-top-style', 'solid']
      # ['borderWidth', '45px', 'border-top-width', '4px'] ???
      ['width', '42px', 'width', '42px']
      ['height', '42px', 'height', '42px']
      ['float', 'left', 'float', 'left']
      ['clear', 'both', 'clear', 'both']
      ['display', 'inline', 'display', 'inline']
      ['listStyle', 'square', 'list-style-type', 'square']
      ['whiteSpace', 'pre', 'white-space', 'pre']
    ]

    for example in examples
      do(example) ->
        if example[0] instanceof Function
          [jsssCode, cssName, cssValue] = example
          it "#{jsssCode.toString().replace(/\s+/g, ' ')}", ->
            givenHTML '<h1 id="a">Foo</h1>'
            JSSSShiv.eval ->
              jsssCode(document.tags.h1)
            expect(getCSS 'a', cssName).toEqual cssValue
        else
          [jsssName, jsssValue, cssName, cssValue] = example
          it "#{jsssName}=#{jsssValue}", ->
            givenHTML '<h1 id="a">Foo</h1>'
            JSSSShiv.eval ->
              document.tags.h1[jsssName] = jsssValue
            expect(getCSS 'a', cssName).toEqual cssValue

  it 'allows capitalized tags', ->
    givenHTML  '<h1 id="a">Foo</h1>'
    JSSSShiv.eval ->
      document.tags.H1.color = "blue"
    expect(getCSS 'a', 'color').toBe  'rgb(0, 0, 255)'

  it 'multiple styles may be applied', ->
    givenHTML '<h1 id="a">Foo</h1>'
    JSSSShiv.eval ->
      document.tags.H1.color = "blue"
      document.tags.H1.bgColor = "red"
    expect(getCSS 'a', 'color').toBe  'rgb(0, 0, 255)'
    expect(getCSS 'a', 'background-color').toBe  'rgb(255, 0, 0)'

  it 'tag styles are inherited by children', ->
    givenHTML  '<h1 id="a">Foo</h1>'
    JSSSShiv.eval ->
      document.tags.BODY.color = "blue"
    expect(getCSS 'a', 'color').toBe  'rgb(0, 0, 255)'

  it 'class.all selector', ->
    givenHTML '<h1 id="a" class="foo">Foo</h1>'
    JSSSShiv.eval ->
      document.classes.foo.all.color = "blue"
    expect(getCSS 'a', 'color').toBe  'rgb(0, 0, 255)'

  it 'class.tag selector', ->
    givenHTML '<h1 id="a" class="foo">Foo</h1><h2 id="b" class="foo">Foo</h2>'
    JSSSShiv.eval ->
      document.classes.foo.h1.color = "blue"
      document.classes.foo.h2.color = "red"
    expect(getCSS 'a', 'color').toBe  'rgb(0, 0, 255)'
    expect(getCSS 'b', 'color').toBe  'rgb(255, 0, 0)'

  it 'allows id as selector', ->
    givenHTML '<h1 id="a">Foo</h1>'
    JSSSShiv.eval ->
      document.ids.a.color = "blue"
    expect(getCSS 'a', 'color').toBe  'rgb(0, 0, 255)'

  it 'allows descendant selectors with contextual()', ->
    givenHTML '<h1><span id="a"></span></h1><span id="b"></span>'
    JSSSShiv.eval ->
      document.tags.span.color = 'red'
      contextual(document.tags.h1, document.tags.span).color = 'blue'
    expect(getCSS 'a', 'color').toBe  'rgb(0, 0, 255)'
    expect(getCSS 'b', 'color').toBe  'rgb(255, 0, 0)'
