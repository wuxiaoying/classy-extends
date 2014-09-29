classy-extends [![Build Status](https://travis-ci.org/wuxiaoying/classy-extends.svg)](https://travis-ci.org/wuxiaoying/classy-extends)
=========

This plugin allows base controllers for Angular Classy.

## Install

Install with `bower`:

```shell
bower install classy-extends
```

Add to your `index.html`:

```html
<script src="/bower_components/angular/angular.js"></script>
<script src="/bower_components/angular-classy/angular-classy.js"></script>
<script src="/bower_components/classy-computed/classy-extends.js"></script>
```

Add `classy` and `classy-extends` to your application module.

```javascript
var app = angular.module('app', ['classy', 'classy-extends']);
```

## Running Tests

Download this repo, `cd` into the repo's directory then run:

```shell
npm install
npm install -g bower # If bower isn't already installed
bower install
npm test
```

## Usage Examples

```javascript
 app.classy.controller({
    name: 'ParentController',
    inject: ['$scope'],
    init: function() {
      this.logs = [];
    },
    someFunc: function() {
      this.logs.push('Parent');
    }
  });

  app.classy.controller({
    name: 'ChildController',
    "extends": 'ParentController',
    init: function() {
      this._super(arguments);
    },
    someFunc: function() {
      this._super(arguments);
      this.logs.push('Child');
    },
  });
```

## License

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
