import Foundation
import PathKit
import Result
import Commandant

private func convert(entries: [Parser.Entry]) -> [String: String] {
    var dict = [String: String]()
    entries.forEach { (entry) in
        dict[entry.key] = entry.translation
    }
    return dict
}

enum ParserError: Error {
    case invalidFormat
}

struct Parser {
    public struct Entry {
        let key: String
        var keyStructure: [String] {
            return key.components(separatedBy: CharacterSet(charactersIn: "."))
        }
        let translation: String

        init(key: String, translation: String) {
            self.key = key
            self.translation = translation
        }
    }

    let entries: [Entry]

    static func create(_ path: String) throws -> Parser {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions(rawValue: 0))

        let plist = try PropertyListSerialization
            .propertyList(from: data, format: nil)

        guard let dict = plist as? [String: String] else {
            throw ParserError.invalidFormat
        }

        return Parser(entries: dict.map { Entry(key: $0, translation: $1) })
    }
}

enum DiffStringError: Error {
}

struct DiffStringOptions: OptionsProtocol {
    let verbose: Bool
    let base: String
    let paths: [String]

    static func create(_ verbose: Bool) -> ([String]) -> DiffStringOptions {
        return { paths in
            let base = paths.first ?? ""
            let paths = Array(paths.dropFirst())
            return DiffStringOptions(verbose: verbose, base: base, paths: paths)
        }
    }

    static func evaluate(_ m: CommandMode) -> Result<DiffStringOptions, CommandantError<DiffStringError>> {
        return create
            <*> m <| Option(key: "verbose", defaultValue: false, usage: "show verbose output")
            <*> m <| Argument(usage: "inputs Localized.strings")
    }
}

struct DiffStringCommand: CommandProtocol {
    let verb = "diff-strings"
    let function = "Diff Localized.strings between base file and other input files"

    private lazy var fileManager = {
        return FileManager.default
    }()

    func run(_ options: DiffStringOptions) -> Result<(), DiffStringError> {
        let baseEntries = loadEntries(path: options.base)
        options.paths.forEach { (path) in
            missingKeys(target: loadEntries(path: path), base: baseEntries).forEach {
                print("warning: missing key \"\($0)\" in \(path)")
            }
        }

        return Result.success()
    }

    private func loadEntries(path: String) -> [Parser.Entry] {
        do {
            let parser = try Parser.create(path)
            return parser.entries
        } catch {
            print(error)
            return []
        }
    }

    private func missingKeys(target: [Parser.Entry], base: [Parser.Entry]) -> [String] {
        let base = convert(entries: base)
        let target = convert(entries: target)
        var ret = [String]()
        base.forEach { (key, _) in
            if target[key] == nil {
                ret.append(key)
            }
        }
        return ret
    }
}
