import XCTest
import PerfectHTTP
@testable import TaskerServerLib

class HealthControllerTests: XCTestCase {
    func testGetHealthShouldReturnMessageAboutHealth() {
        
        // Arrange.
        let healthController = HealthController()
        let fakeRequest = FakeHTTPRequest()
        let fakeResponse = FakeHTTPResponse()
        
        // Act.
        healthController.getHealth(request: fakeRequest, response: fakeResponse)
        
        // Assert.
        XCTAssert(fakeResponse.status.code == HTTPResponseStatus.ok.code)
        XCTAssert(fakeResponse.body != nil)
        XCTAssert(fakeResponse.body!.contains(string: "I'm fine and running!"))
    }


    static var allTests = [
        ("testGetHealthShouldReturnMessageAboutHealth", testGetHealthShouldReturnMessageAboutHealth),
    ]
}
