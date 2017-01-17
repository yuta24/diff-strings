import Foundation

private func main(arguments: [String]) {
//    let arguments = arguments.dropFirst()
//    guard let input = arguments.first else {
//        print("inputの引数を入力してください😡")
//        return
//    }
    let ja = "/Users/yuta24/work/wantedly/yashima-ios/namecard-scanner/ja.lproj/Localizable.strings"
    let en = "/Users/yuta24/work/wantedly/yashima-ios/namecard-scanner/en.lproj/Localizable.strings"
    let command = DiffString(paths: [en], base: ja)
//    let directoryPath = FileManager.default.currentDirectoryPath
//    let generator = DiffString(path: directoryPath)
    command.execute()
}

main(arguments: CommandLine.arguments)
