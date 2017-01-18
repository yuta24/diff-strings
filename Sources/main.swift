import Foundation
import Commandant

private func main(arguments: [String]) {
    let commands = CommandRegistry<DiffStringError>()
    commands.register(DiffStringCommand())

    if let verb = arguments.first {
        let split = verb.components(separatedBy: "/")
        let arguments = arguments.dropFirst()
        guard let command = split.last, let _ = commands.run(command: command, arguments: Array(arguments)) else {
            print("Unrecognized command.")
            return
        }
        // success or failure.
    } else {
        print("No command given.")
    }
}

main(arguments: CommandLine.arguments)
