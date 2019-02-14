# SwiftyLISP

**An embeddable LISP interpreter for Swift**

<p>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift-4.x-orange.svg?style=flat" alt="Swift 4 compatible" /></a>
<a href="https://raw.githubusercontent.com/uraimo/Bitter/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
<a href="https://github.com/apple/swift-package-manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg"/></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-brightgreen.svg"/></a>
<a href="https://cocoapods.org/pods/SwiftyLISP"><img src="https://img.shields.io/cocoapods/v/SwiftyLisp.svg"/></a>
</p>

## Summary

This framework contains an interpreter for the LISP defined in [John McCarthy's micro-manual](https://www.uraimo.com/files/MicroManual-LISP.pdf) and described in [this article](https://www.uraimo.com/2017/02/05/building-a-lisp-from-scratch-with-swift/).

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

Here is a recap of the available operators:

| Atom | Structure | Description |
|------|-----|---------|
| Print    | (print e) | Prints its sub-expression |
| Eval     | (eval e) | Eval evaluates its sub-expression |
| Quote    | (quote e) | This atom once evaluated returns its sub-expression **as is**, _e.g. (quote A) = A_ |
| Car | (car l) | Returns the first element of a non-empty sub-list, _e.g. (car (quote (A B C))) = A_ |
| Cdr | (cdr l) | Returns all the elements of the sub-list after the first in a new list, _e.g. (cdr (quote (A B C))) = (B C)_ |
| Cons | (cons e l) | Returns a new list with e as first element and then the content of the sublist _e.g. (cons (quote A) (quote (B C))) = (A B C)_ |
| Equal | (equal e1 e2) | Returns an atom aptly named **true** if the two symbolic expressions are recursively equal and the empty list **()** (that serves as both nil and false value) if they are not, _e.g. (equal (car (quote (A B))) = (quote A))_ |
| Atom | (atom e) | Returns true if the symbolic expression is an atom or an empty list if it is a lis, _e.g. (atom A) = true_ |
| Cond | (cond (p1 e1) (p2 e2) ... (pn en)) | Returns the first **e** expression whose **p** predicate expression is not equal to the empty list. This is basically a conditional atom with a slightly more convoluted syntax than a common if construct. _e.g. (cond ((atom (quote A)) (quote B)) ((quote true) (quote C) = B_ |
| List | (list e1 e2 ... en) | Returns a list of all the given expressions, identical to applying cons recursively to a sequence of expressions. |
| Lambda | ( (lambda (v1 ... vn) e) p1 ... pn) | Defines a lambda expression with body **e** that describes an anonymous function that uses a series of environment variables **v**. This function will be evaluated using the provided parameters as value for the variables. _e.g. ((lambda (X Y) (cons (car x) y) (quote (A B)) (cdr (quote (C D)))) = (A D)_ |
| Defun | (defun <name> (v1 ... vn) e) | Define a lambda expression and registers it in the current context to be used when we need it. We'll be able to define a function like _(defun cadr (X) (car (cdr x)))_  and use it in another expression like _(cadr (quote (A B C D)))_. |

Additional examples, and the additional functions and acronyms defined in the paper, can be found in the test suite of the framework.

## Installation

The library can be installed with either CocoaPods, Carthage or the SwiftPM.

To include it in your project using the Swift Package Manager, add a dependency to your `Package.swift`:

```swift
import PackageDescription

let package = Package(
    ...
    dependencies: [
        ...
        .Package(url: "https://github.com/uraimo/SwiftyLISP.git")
    ]
)
```

Regardless of how you added the framework to your project, import it with `import SwiftyLisp`. 

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

