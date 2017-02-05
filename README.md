# SwiftyLISP

**An embeddable LISP interpreter for Swift**

<p>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift-3.x-orange.svg?style=flat" alt="Swift 3 compatible" /></a>
<a href="https://raw.githubusercontent.com/uraimo/Bitter/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
<a href="https://github.com/apple/swift-package-manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg"/></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-brightgreen.svg"/></a>
<a href="https://cocoapods.org/pods/SwiftyLISP"><img src="https://img.shields.io/cocoapods/v/SwiftyLISP.svg"/></a>
</p>

## Summary

This framework contains an interpreter for the LISP described in [John McCarthy's micro-manual](https://www.uraimo.com/files/MicroManual-LISP.pdf) and described in [this article](https://www.uraimo.com/2017/02/06/building-a-lisp-from-scratch-with-swift/).

## Usage

The framework converts string literals in nested structures based on the `SExpr` enum that can then be evaluated.

Let's see some usage examples:

```swift
import SwiftyLisp

var expr:SExpr = "(cond ((atom (quote A)) (quote B)) ((quote true) (quote C)))"

print(expr)
dump(expr)
print(expr.eval()!)  //B

expr = "(car ( cdr  ( quote (1 2 \"aaaa\"   4 5 true 6 7 () ))))"
print(expr.eval()!)  //2

expr = "( (lambda (x y) (atom x)) a b)" 
print(expr.eval()!)  //true

expr = "(defun ff (x) (cond ((atom x) x) (true (ff (car x)))))"
print(expr.eval()!)
expr = "(ff (quote ((a b) c)))"
print(expr.eval()!)  //a

expr = "(eval (quote (atom (quote A)))"
print(expr.eval()!)  //true

expr = "(defun alt (x) (cond ((or (null x) (null (cdr x))) x) (true (cons (car x) (alt (cddr x))))))"
print(expr.eval()!)
expr = "(alt (quote (A B C D E))"
print(expr.eval()!)  //(A C E)
 
```

Additional examples can be found in the test suite of the framework.

## Installation

The library can be installed with either CocoaPods, Carthage or the SwiftPM.

To include it in your project using the Swift Package Manager, add a dependency to your `Package.swift`:

```
import PackageDescription

let package = Package(
    ...
    dependencies: [
        ...
        .Package(url: "https://github.com/uraimo/SwiftyLISP.git")
    ]
)
```

Regardless of how you added the framework to your project, import it with `import SwiftyLISP`. 

## Usage

TBD.

## License

The MIT License (MIT)

Copyright (c) 2016 [Umberto Raimondi](https://www.uraimo.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

