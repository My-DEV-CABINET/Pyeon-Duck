// swift-tools-version: 5.9
import PackageDescription

let appName = "Pyeon-Duck"

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "RxDataSources": .framework,
            "RxSwift": .framework,
            "RxCocoa": .framework,
            "RxRelay": .framework,
            "Alamofire": .framework,
        ]
    )
#endif

let package = Package(
    name: appName,
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", from: "5.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.0.0"),
    ],
    targets: [
        .target(
            name: appName,
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "RxDataSources", package: "RxDataSources"),
            ]
        ),
    ]
)
