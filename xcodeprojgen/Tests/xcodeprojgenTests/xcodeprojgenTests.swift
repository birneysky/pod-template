import XCTest
#if DEBUG
@testable  import xcodeprojgen
#else
import xcodeprojgen
#endif

final class xcodeprojgenTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(xcodeprojgen().text, "Hello, World!")
    }
    
    func testCommandCopy() throws {
        let c = Command(name: "cp", arguments: nil)
        XCTAssertEqual(c.name, "cp")
        XCTAssertEqual(c.arguments, nil)
        XCTAssertEqual(try c.exec(), 64)
    }
    
    func testCommandWhich() {
        let c = Command(name: "which", arguments: ["ls"])
        XCTAssertEqual(try c.run().0, 0);
        XCTAssertEqual(try c.run().1, "/bin/ls")
    }
    
    func testProcess()  {
        let process = Process()
        process.launchPath = "a"
        XCTAssertThrowsError(try process.run())
        process.waitUntilExit()
    }
    
    func testResource() {
        let a = Bundle(identifier: "xcodeprojgenTests")
        let e = a?.path(forResource: "Empty", ofType: "md")
        let d = a?.url(forResource: "Empty", withExtension: "md")
        let b = Bundle.allBundles;
        let settingsURL = Bundle.module.url(forResource: "Empty", withExtension: "md")
        print(settingsURL)
    }
}
