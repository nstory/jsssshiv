class window.JSSSShiv
  # https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/HTML5/HTML5_element_list
  tagNames = ['a', 'abbr', 'address', 'area', 'article', 'aside', 'audio', 'b', 'base', 'bdi', 'bdo', 'blockquote', 'body', 'br', 'button', 'canvas', 'caption', 'cite', 'code', 'col', 'colgroup', 'data', 'datalist', 'dd', 'del', 'details', 'dfn', 'div', 'dl', 'dt', 'em', 'embed', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'header', 'hr', 'html', 'i', 'iframe', 'img', 'input', 'ins', 'kbd', 'keygen', 'label', 'legend', 'li', 'link', 'main', 'map', 'mark', 'math', 'menu', 'menuitem', 'meta', 'meter', 'nav', 'noscript', 'object', 'ol', 'optgroup', 'option', 'output', 'p', 'param', 'pre', 'progress', 'q', 'rp', 'rt', 'ruby', 's', 'samp', 'script', 'section', 'select', 'small', 'source', 'span', 'strong', 'style', 'sub', 'summary', 'sup', 'svg', 'table', 'tbody', 'td', 'template', 'textarea', 'tfoot', 'th', 'thead', 'time', 'title', 'tr', 'track', 'u', 'ul', 'var', 'video', 'wbr']

  @uninstall = =>
    if @style? then @style.parentElement.removeChild @style

  @install = =>
    self = this

    # create CSS <style> tag to hold translated styles
    @style = document.createElement 'style'
    @style.id = 'jsss-shiv-styles'
    document.body.appendChild @style

    # populate document.tags with JSSSTag objects
    document.tags = {}
    for tagName in tagNames
      tag = new JSSSTag tagName, @style
      document.tags[tagName] = tag
      document.tags[tagName.toUpperCase()] = tag

    # bad implicit return is bad
    undefined

class JSSSTag
  constructor: (@tagName, @style) ->
    Object.defineProperty this, 'color',
      set: (newValue) ->
        style.innerHTML += "#{tagName} {color: #{newValue};}"

    Object.defineProperty this, 'bgColor',
      set: (newValue) ->
        style.innerHTML += "#{tagName} {background-color: #{newValue};}"
