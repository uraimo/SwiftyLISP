
import SwiftyLisp




let expr:SExpr = "(cond ((atom (quote A)) (quote B)) ((quote true) (quote C)))"

print(expr)
print(expr.eval(environment)!)
