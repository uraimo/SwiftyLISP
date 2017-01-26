
import SwiftyLisp



let expr:SExpr = "(cond ((atom (quote A)) (quote B)) ((quote true) (quote C)))"

print(expr)
print(expr.eval()!)  //B

let e2:SExpr = "(defun TEST (x y) (atom x))"

print(e2)
print(e2.eval()!)  //B

print(localContext)

var e3:SExpr = "(TEST b (quote (a b c)))"
print(e3)
print(e3.eval()!)  // true

e3 = "(TEST (quote (a b c)) b)"
print(e3)
print(e3.eval()!)  // false ()


e3 = "( (lambda (x y) (atom x)) a b)"
print(e3)
print(e3.eval()!)
print(e3.eval()!)
print(localContext)