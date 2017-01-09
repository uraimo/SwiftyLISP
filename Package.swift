import PackageDescription

let package = Package(
    name: "SwiftyLisp",
    targets: [
        Target(name: "SwiftyLispTests", dependencies: [.Target(name: "SwiftyLisp")])
    ]
)
