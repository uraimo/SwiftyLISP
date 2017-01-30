# SwiftyLISP

**An embeddable LISP interpreter for Swift**

<p>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift-3.x-orange.svg?style=flat" alt="Swift 3 compatible" /></a>
<a href="https://raw.githubusercontent.com/uraimo/Bitter/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
<a href="https://github.com/apple/swift-package-manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg"/></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-brightgreen.svg"/></a>
<a href="https://cocoapods.org/pods/SwiftyLISP"><img src="https://img.shields.io/cocoapods/v/Bitter.svg"/></a>
</p>

## Summary

This framework contains a LISP interpreter that can be included in any Swift project.

## Installation

The library can be installed with either CocoaPods, Carthage or the SwiftPM.

To include it in your project using the Swift Package Manager, add a dependency to your `Package.swift`:

``
import PackageDescription

let package = Package(
    ...
    dependencies: [
        ...
        .Package(url: "https://github.com/uraimo/SwiftyLISP.git")
    ]
)
``
Regardless of how you added the framework to your project, import it with `import SwiftyLISP`. 

## Usage

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

