
import SwiftyLisp



let expr:SExpr = "(cond ((atom (quote A)) (quote B)) ((quote true) (quote C)))"

print(expr)
print(expr.eval()!)  //B

let e2:SExpr = "(defun TEST (x y) (atom x))"

print(e2)
print(e2.eval()!)  //B

print(localEnvironment)

let e3:SExpr = "(TEST (quote (a b c)) b)"

print(e3)
print(e3.eval()!)  // false