import Foundation
import PathKit

private func convert(entries: [StringsFileParser.Entry]) -> [String: String] {
    var dict = [String: String]()
    entries.forEach { (entry) in
        dict[entry.key] = entry.translation
    }
    return dict
}

class DiffString {
    let base: String
    let paths: [String]
    private lazy var fileManager = {
        return FileManager.default
    }()
    init(paths: [String], base: String) {
        self.base = base
        self.paths = paths
    }

    func execute() {
        let baseEntries = loadEntries(path: base)
        paths.forEach { (path) in
            missingKeys(target: loadEntries(path: path), base: baseEntries).forEach {
                print("warning: missing key \"\($0)\" in \(path)")
            }
        }
    }

    private func loadEntries(path: String) -> [StringsFileParser.Entry] {
        let parser = StringsFileParser()
        do {
            try parser.parseFile(at: Path(path))
            return parser.entries
        } catch {
            print(error)
            return []
        }
    }

    private func missingKeys(target: [StringsFileParser.Entry], base: [StringsFileParser.Entry]) -> [String] {
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
