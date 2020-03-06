

import Pokedex
import Vapor
import XCTest

final class PokeAPITests: XCTestCase {
  /// Tests the verify name function of our PokeAPI wrapper
  func testverifyName() throws {
    let app = try Application.makeTest()
    let pokeapi = try PokeAPI.makeTest(on: app)
    let isVerified = try pokeapi.verifyName("pikachu", on: app).wait()
    XCTAssertTrue(isVerified)
  }
  
  /// Declare all tests that should be run on Linux.
  static let allTests = [
    ("testverifyName", testverifyName),
  ]
}
