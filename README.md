# JSSS Shiv
This is a shiv, an improvised implement for doing violence upon a web browser. In this case, that violence is [JSSS](http://www.w3.org/Submission/1996/1/WD-jsss-960822).

## Introduction
JSSS (JavaScript-based Style Sheets) was an alternative to CSS proposed by Netscape in the days of the early web. The only browser to implement it was Netscape 4.

This project is a polyfill allowing JSSS to be used in a modern browser. Basically, it converts JSSS into CSS.

## Limitations
### Classes and IDs
JSSS allows you to specify class and id styles using syntax like:

```javascript
// span.foo {color: red;}
document.classes.foo.span.color = 'red';
// #foo {color: red;}
document.ids.foo.color = 'red';
```

Without using something fancy like ES6 proxies, it would be impossible to catch all the possible classes and ids in expressions like the above. Failing to catch such a reference, results in the browser emiting an error like: `Cannot read property 'span' of undefined`.

JSSSShiv takes a novel (i.e. absolutely insane) approach to solving this problem. Passed-in JavaScript is parsed for possible identifiers, and these are added to the `classes` and `ids` objects before the code is executed. For example, given the stylesheet:

```javascript
// bring-out warnings
document.classes.warning.all.color = 'red';
```

The following identifiers will be added to the `ids` and `classes` objects:
`bring-out`, `warning`, `document`, `classes`, `warning`, `all`, `color`, `red`.

Though this will work in most cases, if the classes/ids are constructed dynamically, or if they are hidden behind function calls, you may see "Cannot read property..." errors.

### Apply
The JSSS spec details an apply property which allows a function to be passed into the style engine, and executed whenever a selector is matched. JSSShiv does not support this.

### External stylesheets
No support for external stylesheets (i.e. styles referenced via a `<link>` tag)

## License
MIT
