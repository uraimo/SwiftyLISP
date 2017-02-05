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
    func eval(_ expr:String)->SExpr{
        return SExpr(stringLiteral:expr).eval()!
    }
    
    func testBasicAtoms() {
        XCTAssertEqual(eval("(car ( cdr  ( quote (1 2 \"aaaa\"   4 5 true 6 7 () ))))"), .Atom("2"))
        XCTAssertEqual(eval("(cdr (quote (1 2 3)))"),.List([.Atom("2"),.Atom("3")]))
        XCTAssertEqual(eval("(quote (quote(quote (1 2))))"),.List([ .Atom("quote"),.List([ .Atom("quote"), .List([.Atom("1"),.Atom("2")])])]))
        XCTAssertEqual(eval("(quote (A B C))"), .List([.Atom("A"),.Atom("B"),.Atom("C")]))
        XCTAssertEqual(eval("(equal A A)"), .Atom("true"))
        XCTAssertEqual(eval("(equal () ())"), .Atom("true"))
        XCTAssertEqual(eval("(equal true true)"), .Atom("true"))
        XCTAssertEqual(eval("(equal (quote true) (atom A))"), .Atom("true"))
        XCTAssertEqual(eval("(equal A ())"), .List([]))
        XCTAssertEqual(eval("(quote A)"), .Atom("A"))
        XCTAssertEqual(eval("(quote 1)"), .Atom("1"))
        XCTAssertEqual(eval("(atom A)"), .Atom("true"))
        XCTAssertEqual(eval("(atom (quote (A B)))"), .List([]))
        XCTAssertEqual(eval("(cond ((atom (quote A)) (quote B)) ((quote true) (quote C)))"), .Atom("B"))
        XCTAssertEqual(eval("(list (quote (A B C)))"), .List([.Atom("A"),.Atom("B"),.Atom("C")]))
        XCTAssertEqual(eval("(list (quote A) (quote (B C)))"), .List([.Atom("A"),.Atom("B"),.Atom("C")]))
        XCTAssertEqual(eval("(list (quote A) (quote B) (quote C)))"), .List([.Atom("A"),.Atom("B"),.Atom("C")]))
    }
    
    func testFunctionDefinitions() {
        XCTAssertEqual(eval("( (lambda (x y) (atom x)) () b)"), .List([]))
        XCTAssertEqual(eval("( (lambda (x y) (atom x)) a b)"), .Atom("true"))
        XCTAssertEqual(eval("(defun TEST (x y) (atom x))"), .List([]))
        XCTAssertEqual(eval("(TEST a b)"), .Atom("true"))
        XCTAssertEqual(eval("(TEST (quote (1 2 3)) b)"), .List([]))
    }
    
    func testComplexExpressions() {
        XCTAssertEqual(eval("((car (quote (atom))) A)"),.Atom("true"))
        XCTAssertEqual(eval("((car (quote (atom))) ())"),.List([]))
        XCTAssertEqual(eval("(defun ff (x) (cond ((atom x) x) (true (ff (car x)))))"), .List([])) //Recoursive function
        XCTAssertEqual(eval("(ff (quote ((a b) c)))"), .Atom("a"))
        XCTAssertEqual(eval("(eval (quote (atom (quote A)))"),.Atom("true"))
    }
    
    func testAbbreviations() {
        XCTAssertEqual(eval("(defun null (x) (equal x ()))"), .List([]))
        XCTAssertEqual(eval("(defun cadr (x) (car (cdr x)))"), .List([]))
        XCTAssertEqual(eval("(defun cddr (x) (cdr (cdr x)))"), .List([]))
        XCTAssertEqual(eval("(defun and (p q) (cond (p q) (true ())))"), .List([]))
        XCTAssertEqual(eval("(defun or (p q) (cond (p p) (q q) (true ())) )"), .List([]))
        XCTAssertEqual(eval("(defun not (p) (cond (p ()) (true p))"), .List([]))
        XCTAssertEqual(eval("(defun alt (x) (cond ((or (null x) (null (cdr x))) x) (true (cons (car x) (alt (cddr x))))))"), .List([]))
        XCTAssertEqual(eval("(defun subst (x y z) (cond ((atom z) (cond ((equal z y) x) (true z))) (true (cons (subst x y (car z)) (subst x y (cdr z))))))"), .List([]))
        XCTAssertEqual(eval("(null a)"), .List([]))
        XCTAssertEqual(eval("(null ())"), .Atom("true"))
        XCTAssertEqual(eval("(and a b)"), .Atom("b"))
        XCTAssertEqual(eval("(or a ())"), .Atom("a"))
        XCTAssertEqual(eval("(not a)"), .List([]))
        XCTAssertEqual(eval("(alt (quote (A B C D E))"), .List([.Atom("A"),.Atom("C"),.Atom("E")]))
        //XCTAssertEqual(eval("(subst (quote z) (quote x) (quote (x x x x)))"), .List([.Atom("z"),.Atom("z"),.Atom("z"),.Atom("z")]))
        //XCTAssertEqual(eval("(subst (quote (plus x y)) (quote V) (quote(times x v)))"), .List([.Atom("times"),.Atom("x"),.List([.Atom("plus"),.Atom("x"),.Atom("y"),])]))
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
