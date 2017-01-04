/**
 *  SwiftyLisp
 *
 *  Copyright (c) 2016 Umberto Raimondi. Licensed under the MIT license, as follows:
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import Foundation
import XCTest
import SwiftyLisp

class SwiftyLispTests: XCTestCase {
    
    func testBasicConversions() {
        func eval(expr:String)->SExpr{
            return SExpr(stringLiteral:expr).eval(environment)
        }
        
        XCTAssertEqual(eval("(car ( cdr  ( quote (1 2 \"aaaa\"   4 5 true 6 7 () ))))"), .Atom("2"))
        XCTAssertEqual(eval("(cdr (quote (1 2 3)))"),.List([.Atom("2"),.Atom("3")]))
        XCTAssertEqual(eval("(quote (quote(quote (1 2))))"),.List([ .Atom("quote"),.List([ .Atom("quote"), .List([.Atom("1"),.Atom("2")])])]))
        XCTAssertEqual(eval("(quote (A B C))"), .List([.Atom("A"),.Atom("B"),.Atom("C")]))
        XCTAssertEqual(eval("(quote A)"), .Atom("A"))
        XCTAssertEqual(eval("(quote 1)"), .Atom("1"))
        XCTAssertEqual(eval("(atom A)"), .Atom("true"))
        XCTAssertEqual(eval("(atom (quote (A B)))"), .List([]))
        XCTAssertEqual(eval("(cond ((atom (quote A)) (quote B)) ((quote true) (quote C)))"), .Atom("B"))
    }
}

#if os(Linux)
extension SwiftyLispTests {
    static var allTests : [(String, (SwiftyLispTests) -> () throws -> Void)] {
        return [
            ("testBasicConversions", testBasicConversions),
        ]
    }
}
#endif