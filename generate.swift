#!/usr/bin/swift sh

import Foundation
import PathKit // @kylef ~> 1.0.1

print(CommandLine.arguments)
let path = Path(CommandLine.arguments[0])
print(path)
///RunLoop.main.run()