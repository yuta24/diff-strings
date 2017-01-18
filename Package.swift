import PackageDescription

let package = Package(
    name: "diff-strings",
    dependencies: [
        .Package(url: "git@github.com:kylef/PathKit.git", majorVersion: 0),
        .Package(url: "git@github.com:Carthage/Commandant.git", majorVersion: 0),
        ]
)
