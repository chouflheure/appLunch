
import Foundation

struct Logger {
    static func log(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let filename = (file as NSString).lastPathComponent
        print("\(level.rawValue) - [\(filename):\(line)] - \(function) -> \(message)")
        #endif
    }
}


