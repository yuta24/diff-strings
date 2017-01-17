import Foundation

private func main(arguments: [String]) {
    let arguments = arguments.dropFirst()
    guard arguments.count >= 2 else { print("please input more than 2 files."); return }
    guard let base = arguments.last else { return }
    let targets = arguments.dropLast()
    let command = DiffString(paths: Array(targets), base: base)
    command.execute()
}

main(arguments: CommandLine.arguments)
