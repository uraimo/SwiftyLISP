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

// Enum for S-Expressions
public enum SExpr{
    case Atom(String)
    case List([SExpr])
    
    /**
     Evaluates this SExpression with the given functions environment
     
     - Parameter environment: A set of named functions or the default environment
     - Returns: the resulting SExpression after evaluation
     */
    public func eval(_ environment: [String: (SExpr)->SExpr] = defaultEnvironment) -> SExpr?{
        var node = self
        
        switch node {
        case .Atom:
            return node
        case var .List(elements):
            //Quoted, stop evaluation
            if elements.count > 1, case let .Atom(value) = elements[0], Builtins.isQuoted(value) {
                return elements[1]
            }
            
            // Evaluate all subexpressions
            //TODO: print("Iterating on ",elements)
            for (id,expr) in elements.enumerated() {
                if case .List(_) = expr {
                    elements[id] = expr.eval(environment)!
                }
            }
            //TODO: print("Result ",elements)
            node = .List(elements)
            
            // Obtain a a reference to the function represented by the first atom and apply it
            if case let .Atom(value) = elements[0], let f = environment[value] {
                let r = f(node)
                //TODO: print("Evaluated \(value) with result: \(r)")
                return r
            }
            
            return node
        }
    }
    
}

/// Extension that implements a recursive Equatable
extension SExpr : Equatable {
    public static func ==(lhs: SExpr, rhs: SExpr) -> Bool{
        switch(lhs,rhs){
        case let (.Atom(l),.Atom(r)):
            return l==r
        case let (.List(l),.List(r)):
            guard l.count == r.count else {return false}
            for (idx,el) in l.enumerated() {
                if el != r[idx] {
                    return false
                }
            }
            return true
        default:
            return false
        }
    }
}

/// Extension that implements CustomStringConvertible to pretty-print the S-Expression
extension SExpr : CustomStringConvertible{
    public var description: String {
        switch self{
        case let .Atom(value):
            return "\(value) "
        case let .List(subxexprs):
            var res = "("
            for expr in subxexprs{
                res += "\(expr) "
            }
            res += ")"
            return res
        }
    }
}


/// Extension needed to convert string literals to SExpr
extension SExpr : ExpressibleByStringLiteral,ExpressibleByUnicodeScalarLiteral,ExpressibleByExtendedGraphemeClusterLiteral {

    public init(stringLiteral value: String){
        self = SExpr.read(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String){
        self.init(stringLiteral: value)
    }
    
    public init(unicodeScalarLiteral value: String){
        self.init(stringLiteral: value)
    }
    
}

/// Tokenize and parsing extension
extension SExpr {
    
    /**
     Read a lisp string and convert it to a hierarchical S-Expression
    */
    fileprivate static func read(_ sexpr:String) -> SExpr{
        
        struct ParseError: Error {
            var message: String
        }
        
        func appendTo(list: SExpr?, node:SExpr) -> SExpr {
            var list = list
            
            if list != nil, case var .List(elements) = list! {
                elements.append(node)
                list = .List(elements)
            }else{
                list = node
            }
            return list!
        }
        
        enum Token{
            case pOpen,pClose,textBlock(String)
        }
        
        /**
         Break down a string to a series of tokens
         
         - Parameter sexpr: Stringified S-Expression
         - Returns: Series of tokens
        */
        func tokenize(_ sexpr:String) -> [Token] {
            var res = [Token]()
            var tmpText = ""
            
            for c in sexpr.characters {
                switch c {
                case "(":
                    if tmpText != "" {
                        res.append(.textBlock(tmpText))
                        tmpText = ""
                    }
                    res.append(.pOpen)
                case ")":
                    if tmpText != "" {
                        res.append(.textBlock(tmpText))
                        tmpText = ""
                    }
                    res.append(.pClose)
                case " ":
                    if tmpText != "" {
                        res.append(.textBlock(tmpText))
                        tmpText = ""
                    }
                default:
                    tmpText.append(c)
                }
            }
            return res
        }
        
        /**
         Parses a series of tokens to obtain a hierachical S-Expression
         
         - Parameter tokens: Tokens to parse
         - Parameter node: Parent S-Expression if available
         
         - Returns: Tuple with remaning tokens and resulting S-Expression
        */
        func parse(_ tokens: [Token], node: SExpr? = nil) -> ([Token], SExpr?) {
            var tokens = tokens
            var node = node
            
            var i = 0
            repeat {
                let t = tokens[i]
                
                switch t {
                case .pOpen:
                    //new sexpr
                    let (tr,n) = parse( Array(tokens[(i+1)..<tokens.count]), node: .List([]))
                    assert(n != nil) //Cannot be nil
                    
                    (tokens, i) = (tr, 0)
                    node = appendTo(list: node, node: n!)
                    
                    if tokens.count != 0 {
                        continue
                    }else{
                        break
                    }
                case .pClose:
                    //close sexpr
                    return (Array(tokens[(i+1)..<tokens.count]),node: node)
                case let .textBlock(value):
                    node = appendTo(list: node, node: .Atom(value))
                }
                
                i += 1
            }while(tokens.count > 0)
            
            return ([],node)
        }
        
        let tokens = tokenize(sexpr)
        let res = parse(tokens)
        return res.1 ?? .List([])
    }
}


/// Basic builtins
fileprivate enum Builtins:String{
    case quote,car,cdr,cons,equal,atom,cond,lambda,label,defun
    
    /**
     True if the given parameter is the quote builtin
     
     - Paramerer atom: Stringified atom
     - Returns: True if the atom is the quote operation
    */
    public static func isQuoted(_ atom: String) -> Bool {
        return atom == Builtins.quote.rawValue
    }
}

/// Global default builtin function environment
fileprivate let defaultEnvironment: [String: (SExpr)->SExpr] = {
    
    var env = [String: (SExpr)->SExpr]()
    env[Builtins.quote.rawValue] = { params in
        guard case let .List(parameters) = params, parameters.count == 2 else {return .List([])}
        return parameters[1]
    }
    env[Builtins.car.rawValue] = { params in
        guard case let .List(parameters) = params, parameters.count == 2 else {return .List([])}
        guard case let .List(elements) = parameters[1] else {return .List([])}
        
        return elements.first!
    }
    env[Builtins.cdr.rawValue] = { params in
        guard case let .List(parameters) = params, parameters.count == 2 else {return .List([])}
        
        guard case let .List(elements) = parameters[1] else {return .List([])}
        
        return .List(Array(elements.dropFirst(1)))
    }
    env[Builtins.cons.rawValue] = { params in
        guard case let .List(parameters) = params, parameters.count == 3 else {return .List([])}
        
        guard case .List(let elRight) = parameters[2] else {return .List([])}
        
        switch parameters[1]{
        case .Atom:
            return .List([parameters[1]]+elRight)
        default:
            return .List([])
        }
    }
    env[Builtins.atom.rawValue] = { params in
        guard case let .List(parameters) = params, parameters.count == 2 else {return .List([])}
        
        switch parameters[1] {
        case .Atom:
            return .Atom("true")
        default:
            return .List([])
        }
    }
    env[Builtins.equal.rawValue] = {params in
        guard case let .List(parameters) = params, parameters.count == 2 else {return .List([])}
        guard case let .List(elements) = params else {return .List([])}
        
        var me = env[Builtins.equal.rawValue]!
        
        switch (elements[1],elements[2]) {
        case (.Atom(let elLeft),.Atom(let elRight)):
            return elLeft == elRight ? .Atom("true") : .List([])
        case (.List(let elLeft),.List(let elRight)):
            guard elLeft.count == elRight.count else {return .List([])}
            for (idx,el) in elLeft.enumerated() {
                let testeq:[SExpr] = [.Atom("Equal"),el,elRight[idx]]
                if me(.List(testeq)) != SExpr.Atom("true") {
                    return .List([])
                }
            }
            return .Atom("true")
        default:
            return .List([])
        }
    }
    env[Builtins.cond.rawValue] = { params in
        guard case let .List(parameters) = params, parameters.count > 1 else {return .List([])}
        
        for el in parameters.dropFirst(1) {
            guard case let .List(c) = el, c.count == 2 else {return .List([])}
            
            if c[0] != .List([]) {
                return c[1]
            }
        }
        return .List([])
    }

    return env
}()


