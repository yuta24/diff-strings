import PackageDescription

let package = Package(
    name: "diff-strings",
    dependencies: [
        .Package(url: "git@github.com:kylef/PathKit.git", majorVersion: 0),
        ]
)
