#!/usr/bin/swift sh

import Swift
import Foundation
import PathKit // @kylef ~> 1.0.1



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
        fatalError("command \(command) not found")
    }
	let process = Process()
    process.launchPath = commandPath;
    if let argv = arguments {
        process.arguments = argv
    }
    let pipe = Pipe()
    process.standardOutput = pipe
    process.launch()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String? = String(data: data, encoding: .utf8)
    process.waitUntilExit()
    pipe.fileHandleForReading.closeFile()
    return (process.terminationStatus, output)
}

func fullPath(of command: String) -> String? {
    let pathes = ["/bin", "/usr/bin", "/usr/local/bin", "/usr/sbin", "/sbin"]
    for path in pathes {
        do {
            let  (status, message) = try exec("/usr/bin/mdfind", arguments: ["-name", command, "-onlyin", "/bin"])        
            if status == 0, let cmdPath = message {
                return cmdPath.trimmingCharacters(in:.whitespacesAndNewlines);
            }
        } catch {
            print("Unexpected error: \(error).")
            return nil
        }
    }
    return nil
}


let enviroment = ProcessInfo.processInfo.environment
if let shell = enviroment["SHELL"] {
	print("SHELL is \(shell)")
}

print(fullPath(of: "cp"))
run("say", arguments: ["ladies and gentlemen, may i have your attention please, i have a very import announcement to make"])
let  (status, message) = exec("/usr/bin/whereis",arguments: ["ls"])
guard status == 0, let msg = message else {
	fatalError()
}
print("status:\(status), \(msg)")
print(fullPath(of: "cp"))
print(CommandLine.arguments)
let path = Path(CommandLine.arguments[0])
print(path)
///RunLoop.main.run()