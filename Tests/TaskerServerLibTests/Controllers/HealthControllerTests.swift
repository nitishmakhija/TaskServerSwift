import XCTest
import PerfectHTTP
@testable import TaskerServerLib

class HealthControllerTests: XCTestCase {

    private var serverContext: TestServerContext!

    override func setUp() {
        self.serverContext = TestServerContext.shared
    }

    func testGetHealthShouldReturnMessageAboutHealth() {

        // Arrange.
        let fakeRequest = FakeHTTPRequest()
        let fakeResponse = FakeHTTPResponse()

        // Act.
        serverContext.healthController.getAction(for: HealthAction.self)?.handler(request: fakeRequest, response: fakeResponse)

        // Assert.
        XCTAssert(fakeResponse.status.code == HTTPResponseStatus.ok.code)
        XCTAssert(fakeResponse.body != nil)
        XCTAssert(fakeResponse.body!.contains(string: "I'm fine and running!"))
    }

    static var allTests = [
        ("testGetHealthShouldReturnMessageAboutHealth", testGetHealthShouldReturnMessageAboutHealth)
    ]
}
