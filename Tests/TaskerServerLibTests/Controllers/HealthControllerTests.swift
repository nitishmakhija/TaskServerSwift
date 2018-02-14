import XCTest
import PerfectHTTP
@testable import TaskerServerLib

class HealthControllerTests: XCTestCase {
    func testGetHealthShouldReturnMessageAboutHealth() {
        
        // Arrange.
        let healthController = HealthController()
        let request = FakeHTTPRequest()
        let response = FakeHTTPResponse()
        
        // Act.
        healthController.getHealth(request: request, response: response)
        
        // Assert.
        XCTAssert(response.status.code == HTTPResponseStatus.ok.code)
        XCTAssert(response.body != nil)
        XCTAssert(response.body!.contains(string: "I'm fine and running!"))
    }


    static var allTests = [
        ("testGetHealthShouldReturnMessageAboutHealth", testGetHealthShouldReturnMessageAboutHealth),
    ]
}
