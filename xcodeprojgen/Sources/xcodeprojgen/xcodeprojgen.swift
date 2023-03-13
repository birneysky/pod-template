
import Swift
import Foundation

@main
public struct xcodeprojgen {
    public let text = "Hello, World!"

    public static func main() {
        print(xcodeprojgen().text)
        let enviroment = ProcessInfo.processInfo.environment
        if let shell = enviroment["SHELL"] {
            print("SHELL is \(shell)")
        }
        
        
        var thisModuleName = "xcodeprojgen_xcodeprojgen"
        var url = Bundle.main.bundleURL
        url = url.appendingPathComponent("\(thisModuleName).bundle")
                
            guard let bundle = Bundle(url: url) else {
                    fatalError("Foundation.Bundle.module could not load resource bundle: \(url.path)")
                }
    /// https://stackoverflow.com/questions/47177036/use-resources-in-unit-tests-with-swift-package-manager
        let ppp = bundle.url(forResource: "project.yml", withExtension: nil, subdirectory: "Resources");
//
        let b = Bundle.allBundles;
        let a = Bundle.main.path(forResource: "project", ofType: "yml")
        #if XCODE_BUILD
        let settingsURL = Bundle.module.url(forResource: "Templates", withExtension: nil)
        #else
        let settingsURL = Bundle.module.url(forResource: "Templates", withExtension: nil)
        #endif
        print(settingsURL)
        print(fullPath(of: "cp") ?? "")
        exec("say", arguments: ["ladies and gentlemen, may i have your attention please, i have a very import announcement to make"])
//        run("whereis",arguments: ["ls"])
//        print(fullPath(of: "cp"))
//        print(CommandLine.arguments)
    }
}


@discardableResult
func run(_ command:String, arguments:[String]? = nil) -> (Int32) {
    guard let commandPath = fullPath(of: command) else {
        fatalError("command \(command) not found")
    }
    let process = Process()
    process.launchPath = commandPath
    if let argv = arguments {
        process.arguments = argv
    }
    process.launch()
    process.waitUntilExit()
    return (process.terminationStatus)
}

@discardableResult
func exec(_ command: String, arguments:[String]? = nil) ->(Int32, String?) {
    guard let commandPath = fullPath(of: command) else {
        return (-1, "\(command) not found");
    }
    return _exec(commandPath, arguments: arguments);
}

func _exec(_ commandPath: String, arguments:[String]? = nil) ->(Int32, String?) {
    let process = Process()
    process.launchPath = commandPath;
    if let argv = arguments {
        process.arguments = argv
    }
    let pipe = Pipe()
    process.standardOutput = pipe
    process.launch()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String? = data.isEmpty ? nil : String(data: data, encoding: .utf8)
    process.waitUntilExit()
    pipe.fileHandleForReading.closeFile()
    return (process.terminationStatus, output)

}

func fullPath(of command: String) -> String? {
    let pathes = ["/bin", "/usr/bin", "/usr/local/bin", "/usr/sbin", "/sbin"]
    for path in pathes {
        let  (status, message) = _exec("/usr/bin/find", arguments: [path, "-name", command])
        if status == 0, let cmdPath = message {
            return cmdPath.trimmingCharacters(in:.whitespacesAndNewlines);
        }
    }
    return nil
}

