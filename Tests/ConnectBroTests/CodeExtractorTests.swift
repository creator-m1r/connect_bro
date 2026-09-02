import XCTest
@testable import ConnectBro

final class CodeExtractorTests: XCTestCase {
    func testExtractsSwiftBlock() {
        let text = "Ответ:\n```swift\nlet value = 42\n```"
        let result = CodeExtractor.extract(from: text)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.language, "swift")
        XCTAssertEqual(result.first?.content, "let value = 42")
    }

    func testIgnoresTextWithoutFence() {
        XCTAssertTrue(CodeExtractor.extract(from: "обычный текст").isEmpty)
    }
}
