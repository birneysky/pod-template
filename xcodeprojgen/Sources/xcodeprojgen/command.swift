//
//  File.swift
//  
//
//  Created by Bruce on 2023/2/23.
//

import Foundation

struct Command {
    let name: String
    let arguments: [String]?
    
    private func comandFullPath() throws -> String? {
        let pathes = ["/bin", "/usr/bin", "/usr/local/bin", "/usr/sbin", "/sbin"]
        for path in pathes {
            do {
                let (status, message) =  try Command._exec("/usr/bin/find", arguments: [path, "-name", name])
                if status == 0, let cmdPath = message {
                    return cmdPath.trimmingCharacters(in:.whitespacesAndNewlines)
                }
            } catch {
                throw error
            }
        }
        return nil
    }
    
    private static func _exec(_ commandPath: String, arguments:[String]? = nil) throws ->(Int32, String?) {
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
        return (process.terminationStatus, output?.trimmingCharacters(in:.whitespacesAndNewlines))

    }
    
    @discardableResult
    func exec() throws -> Int32 {
        guard let command = try comandFullPath() else {
            return -1
        }
        
        do {
            return try Command._exec(command, arguments: arguments).0
        } catch {
            throw error
        }
    }
    
    @discardableResult
    func run() throws -> (Int32, String?) {
        guard let command = try comandFullPath() else {
            return (-1, "\(name) not found");
        }
        do {
            return  try Command._exec(command, arguments: arguments)
        } catch {
            throw error
        }
    }
}
