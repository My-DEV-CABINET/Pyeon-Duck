import ProjectDescription

/// Pyeon-Duck
let appName = "Pyeon-Duck"
/// Pyeon-DuckTests
let testName = "Pyeon-DuckTests"

/// BundleID
let bundleAppID = "com.Junwoo.Jununu.Pyeon-Duck"
let bundleTestID = "com.Junwoo.Jununu.Pyeon-DuckTests"

/// Info
let info: InfoPlist = "Configs/Info.plist"

/// Sources
let sources: SourceFilesList = ["Pyeon-Duck/Sources/**"]

/// Resources
let resources: ResourceFileElements = ["Pyeon-Duck/Resources/**"]

/// Tests
let tests: SourceFilesList = ["Pyeon-Duck/Tests/**"]

/// Config
let config = "Configs/Pyeon-Duck.xcconfig"

/// CoreData
let coredata: Path = "Pyeon-Duck/Sources/Models/Model.xcdatamodeld"

/// Settings
enum Settings: ConfigurationName {
    case debug = "Debug"
    case release = "Release"
}

/// Version
let version = "16.0"

let project = Project(
    name: appName,
    targets: [
        .target(
            name: appName,
            destinations: .iOS,
            product: .app,
            bundleId: bundleAppID,
            deploymentTargets: .iOS(version),
            infoPlist: info,
            sources: sources,
            resources: resources,
            dependencies: [],
            settings: .settings(configurations: [
                .debug(
                    name: Settings.debug.rawValue,
                    xcconfig: .relativeToRoot(config)
                ),
                .release(
                    name: Settings.release.rawValue,
                    xcconfig: .relativeToRoot(config)
                )
            ]),
            coreDataModels: [
                .coreDataModel(coredata)
            ]
        ),
        .target(
            name: testName,
            destinations: .iOS,
            product: .unitTests,
            bundleId: bundleTestID,
            deploymentTargets: .iOS(version),
            infoPlist: nil,
            sources: tests,
            resources: [],
            dependencies: [.target(name: appName)]
        )
    ]
)
