(function() {
  var JSSSClass, JSSSId, JSSSShiv, JSSSTag, JSSSThing, stylings,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.JSSSShiv = JSSSShiv = (function() {
    function JSSSShiv() {}

    JSSSShiv.tagNames = ['a', 'abbr', 'address', 'area', 'article', 'aside', 'audio', 'b', 'base', 'bdi', 'bdo', 'blockquote', 'body', 'br', 'button', 'canvas', 'caption', 'cite', 'code', 'col', 'colgroup', 'data', 'datalist', 'dd', 'del', 'details', 'dfn', 'div', 'dl', 'dt', 'em', 'embed', 'fieldset', 'figcaption', 'figure', 'footer', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'header', 'hr', 'html', 'i', 'iframe', 'img', 'input', 'ins', 'kbd', 'keygen', 'label', 'legend', 'li', 'link', 'main', 'map', 'mark', 'math', 'menu', 'menuitem', 'meta', 'meter', 'nav', 'noscript', 'object', 'ol', 'optgroup', 'option', 'output', 'p', 'param', 'pre', 'progress', 'q', 'rp', 'rt', 'ruby', 's', 'samp', 'script', 'section', 'select', 'small', 'source', 'span', 'strong', 'style', 'sub', 'summary', 'sup', 'svg', 'table', 'tbody', 'td', 'template', 'textarea', 'tfoot', 'th', 'thead', 'time', 'title', 'tr', 'track', 'u', 'ul', 'var', 'video', 'wbr'];

    JSSSShiv.clear = function() {
      if (JSSSShiv.style != null) {
        return JSSSShiv.style.innerHTML = '';
      }
    };

    JSSSShiv["eval"] = function(fn) {
      JSSSShiv._install(JSSSShiv._identifiers(fn.toString()));
      return fn();
    };

    JSSSShiv.run = function() {
      var elem, fn, style, _i, _j, _len, _len1, _ref, _ref1, _results;
      _ref = document.getElementsByTagName('style');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        style = _ref[_i];
        if (!(/javascript/i.test(style.type))) {
          continue;
        }
        fn = new Function([], style.innerHTML);
        JSSSShiv["eval"](fn);
      }
      _ref1 = document.getElementsByTagName('*');
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        elem = _ref1[_j];
        if (elem.hasAttribute('style')) {
          _results.push(JSSSShiv._apply(elem, elem.getAttribute('style')));
        }
      }
      return _results;
    };

    JSSSShiv.contextual = function() {
      var selector, thing;
      selector = ((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = arguments.length; _i < _len; _i++) {
          thing = arguments[_i];
          _results.push(thing.selector);
        }
        return _results;
      }).apply(JSSSShiv, arguments)).join(' ');
      return new JSSSThing(selector, JSSSShiv.style);
    };

    JSSSShiv._install = function(identifiers) {
      var ident, tag, tagName, _i, _j, _k, _len, _len1, _len2, _ref;
      if (JSSSShiv.style == null) {
        JSSSShiv.style = document.createElement('style');
        JSSSShiv.style.id = 'jsss-shiv-styles';
        document.body.appendChild(JSSSShiv.style);
      }
      if (window.contextual == null) {
        window.contextual = JSSSShiv.contextual;
      }
      if (document.tags == null) {
        document.tags = {};
        _ref = JSSSShiv.tagNames;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          tagName = _ref[_i];
          tag = new JSSSTag(tagName, JSSSShiv.style);
          document.tags[tagName] = tag;
          document.tags[tagName.toUpperCase()] = tag;
        }
      }
      if (document.classes == null) {
        document.classes = {};
      }
      for (_j = 0, _len1 = identifiers.length; _j < _len1; _j++) {
        ident = identifiers[_j];
        if (document.classes[ident] == null) {
          document.classes[ident] = new JSSSClass(ident, JSSSShiv.style);
        }
      }
      if (document.ids == null) {
        document.ids = {};
      }
      for (_k = 0, _len2 = identifiers.length; _k < _len2; _k++) {
        ident = identifiers[_k];
        if (document.ids[ident] == null) {
          document.ids[ident] = new JSSSId(ident, JSSSShiv.style);
        }
      }
      return void 0;
    };

    JSSSShiv._apply = function(elem, style) {
      var argumentFunctions, argumentNames, argumentValues, cssRules, defineMethod, defineProperty, error, idx, newValues, nv, styleFn, _i, _len;
      argumentNames = [];
      argumentValues = [];
      argumentFunctions = [];
      cssRules = [];
      defineProperty = function(name, fn) {
        argumentNames.push(name);
        argumentValues.push(void 0);
        return argumentFunctions.push(function(newValue) {
          return cssRules.push(fn(newValue));
        });
      };
      defineMethod = function(name, fn) {
        argumentNames.push(name);
        argumentValues.push(function() {
          return cssRules.push(fn.apply(null, arguments));
        });
        return argumentFunctions.push(function() {});
      };
      stylings(defineProperty, defineMethod);
      try {
        styleFn = new Function(argumentNames, "" + style + ";return arguments;");
        newValues = styleFn.apply(null, argumentValues);
        for (idx = _i = 0, _len = newValues.length; _i < _len; idx = ++_i) {
          nv = newValues[idx];
          if (nv !== void 0) {
            argumentFunctions[idx](nv);
          }
        }
        return elem.setAttribute('style', cssRules.join(';'));
      } catch (_error) {
        error = _error;
        return void 0;
      }
    };

    JSSSShiv._identifiers = function(text) {
      var idents, match, re;
      idents = [];
      re = /[\w\-]+/g;
      while ((match = re.exec(text))) {
        idents.push(match[0]);
      }
      return idents;
    };

    return JSSSShiv;

  })();

  JSSSThing = (function() {
    function JSSSThing(selector, styleElement, pseudoElements) {
      this.selector = selector;
      this.styleElement = styleElement;
      if (pseudoElements == null) {
        pseudoElements = true;
      }
      this.defineMethod = __bind(this.defineMethod, this);
      this.defineProperty = __bind(this.defineProperty, this);
      stylings(this.defineProperty, this.defineMethod);
      if (pseudoElements) {
        this.firstLine = new JSSSThing("" + this.selector + ":first-line", this.styleElement, false);
        this.firstLetter = new JSSSThing("" + this.selector + ":first-letter", this.styleElement, false);
      }
    }

    JSSSThing.prototype.defineProperty = function(name, fn) {
      return Object.defineProperty(this, name, {
        set: (function(_this) {
          return function(newValue) {
            var rule;
            rule = fn(newValue);
            return _this.styleElement.innerHTML += "" + _this.selector + " {" + rule + ";}";
          };
        })(this)
      });
    };

    JSSSThing.prototype.defineMethod = function(name, fn) {
      return this[name] = (function(_this) {
        return function() {
          var rule;
          rule = fn.apply(null, arguments);
          return _this.styleElement.innerHTML += "" + _this.selector + " {" + rule + ";}";
        };
      })(this);
    };

    return JSSSThing;

  })();

  JSSSTag = (function(_super) {
    __extends(JSSSTag, _super);

    function JSSSTag(tagName, style) {
      JSSSTag.__super__.constructor.call(this, "" + tagName, style);
    }

    return JSSSTag;

  })(JSSSThing);

  JSSSClass = (function() {
    function JSSSClass(className, style) {
      var tagName, _i, _len, _ref;
      _ref = JSSSShiv.tagNames;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tagName = _ref[_i];
        this[tagName] = new JSSSThing("" + tagName + "." + className, style);
        this[tagName.toUpperCase()] = new JSSSThing("" + tagName + "." + className, style);
      }
      this.all = new JSSSThing("." + className, style);
    }

    return JSSSClass;

  })();

  JSSSId = (function(_super) {
    __extends(JSSSId, _super);

    function JSSSId(id, style) {
      JSSSId.__super__.constructor.call(this, "#" + id, style);
    }

    return JSSSId;

  })(JSSSThing);

  stylings = function(defineProperty, defineMethod) {
    var side, _fn, _i, _len, _ref;
    defineProperty('fontSize', function(value) {
      return "font-size: " + value;
    });
    defineProperty('fontStyle', function(value) {
      if (value === 'small-caps') {
        return "font-variant: small-caps";
      } else {
        return "font-style: " + value;
      }
    });
    defineProperty('lineHeight', function(value) {
      return "line-height: " + value;
    });
    defineProperty('color', function(value) {
      return "color: " + value;
    });
    defineProperty('background', function(value) {
      return "background-image: url(" + value + ")";
    });
    defineProperty('bgColor', function(value) {
      return "background-color: " + value;
    });
    defineProperty('wordSpacing', function(value) {
      return "word-spacing: " + value;
    });
    defineProperty('letterSpacing', function(value) {
      return "letter-spacing: " + value;
    });
    defineProperty('textDecoration', function(value) {
      return "text-decoration: " + value;
    });
    defineProperty('verticalAlign', function(value) {
      return "vertical-align: " + value;
    });
    defineProperty('textTransform', function(value) {
      return "text-transform: " + value;
    });
    defineProperty('textAlign', function(value) {
      return "text-align: " + value;
    });
    defineProperty('textIndent', function(value) {
      return "text-indent: " + value;
    });
    _ref = ['left', 'right', 'top', 'bottom'];
    _fn = (function(_this) {
      return function(side) {
        defineProperty("" + side + "Margin", function(value) {
          return "margin-" + side + ": " + value;
        });
        return defineProperty("" + side + "Padding", function(value) {
          return "padding-" + side + ": " + value;
        });
      };
    })(this);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      side = _ref[_i];
      _fn(side);
    }
    defineMethod('margins', function(top, right, bottom, left) {
      return "margin: " + top + " " + right + " " + bottom + " " + left;
    });
    defineMethod('paddings', function(top, right, bottom, left) {
      return "padding: " + top + " " + right + " " + bottom + " " + left;
    });
    defineProperty('borderStyle', function(value) {
      return "border-style: " + value;
    });
    defineProperty('borderWidth', function(value) {
      return "border-width: " + value;
    });
    defineProperty('width', function(value) {
      return "width: " + value;
    });
    defineProperty('height', function(value) {
      return "height: " + value;
    });
    defineProperty('float', function(value) {
      return "float: " + value;
    });
    defineProperty('clear', function(value) {
      return "clear: " + value;
    });
    defineProperty('display', function(value) {
      return "display: " + value;
    });
    defineProperty('listStyle', function(value) {
      return "list-style: " + value;
    });
    return defineProperty('whiteSpace', function(value) {
      return "white-space: " + value;
    });
  };

  document.addEventListener("DOMContentLoaded", JSSSShiv.run);

}).call(this);

//# sourceMappingURL=jsssshiv.js.map
