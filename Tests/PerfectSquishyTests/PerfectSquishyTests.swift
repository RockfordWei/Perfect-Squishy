import XCTest
@testable import PerfectSquishy

class PerfectSquishyTests: XCTestCase {
  let sampleScript1 = """
<%
import Foundation
func add(a: Int, b: Int) -> {
  return a + b
}
%>
<HTML><HEAD><META CHARSET=\"UTF-8\">
<TITLE>测试脚本</TITLE>
</HEAD><BODY>
<?
  let x = UUID()
  let y = \"\\(x)\"
  response.setHeader(.contentType, value: "text/html")
?>
<H1>你好！ \\(y) 和 \\(add(a: 1, b: 2))</H1>
</BODY></HTML>
"""
  static var allTests = [
    ("testExample", testExample),
    ]

  func testExample() {
    do {
      let from = "/tmp/test.php"
      let to = "/tmp/test.swift"
      try sampleScript1.write(to: URL(fileURLWithPath: from), atomically: true, encoding: .utf8)
      let parser = Squishy(handler: "handlerX", from: from, to: to)
      try parser.parse()
      let data = try Data(contentsOf: URL(fileURLWithPath: to))
      guard let outcome = String(bytes: data, encoding: .utf8) else {
        XCTFail("outcome \(to) is not available")
        return
      }
      debugPrint(outcome)
    } catch {
      XCTFail("\(error)")
    }
  }
}

