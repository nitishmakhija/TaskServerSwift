import XCTest
import PerfectHTTP
@testable import TaskerServerLib

class HealthControllerTests: XCTestCase {
    
    let serverContext = try! TestServerContext()
    
    func testGetHealthShouldReturnMessageAboutHealth() {
        
        // Arrange.
        let fakeRequest = FakeHTTPRequest()
        let fakeResponse = FakeHTTPResponse()
        
        // Act.
        serverContext.healthController.get(request: fakeRequest, response: fakeResponse)
        
        // Assert.
        XCTAssert(fakeResponse.status.code == HTTPResponseStatus.ok.code)
        XCTAssert(fakeResponse.body != nil)
        XCTAssert(fakeResponse.body!.contains(string: "I'm fine and running!"))
    }


    static var allTests = [
        ("testGetHealthShouldReturnMessageAboutHealth", testGetHealthShouldReturnMessageAboutHealth),
    ]
}
