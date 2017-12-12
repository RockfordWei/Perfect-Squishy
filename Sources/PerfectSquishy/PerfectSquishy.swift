import Foundation
import sqparser

public class Squishy {
  public enum Exception: Error {
    case Syntax(String)
  }
  struct Block {
    public var `type`: Int32 = HTML
    public var content = ""
  }
  var blocks: [Block] = []
  var parserError: Exception? = nil
  let sourcePath: String
  let targetPath: String
  let handlerName: String
  public var debug = false
  public init(handler: String, from: String, to: String) {
    sourcePath = from
    targetPath = to
    handlerName = handler
  }

  public func parse() throws {
    blocks.removeAll(keepingCapacity: false)
    let me = Unmanaged.passUnretained(self).toOpaque()
    parse_squishy(me, sourcePath) { object, state, line in
      guard let obj = object,
        let pointer = line,
        let text = String(validatingUTF8: pointer),
        !text.isEmpty
        else { return }

      let this = Unmanaged<Squishy>.fromOpaque(obj).takeUnretainedValue()
      switch state {
      case HTML, SWIFT_HEAD, SWIFT_BODY:
        let block = Block(type: state, content: text)
        this.blocks.append(block)
        break
      default:
        this.parserError = Exception.Syntax(text)
      }
    }
    if let err = parserError {
      throw err
    }
    var head = ""
    var body = ""
    for block in blocks {
      switch block.type {
      case SWIFT_HEAD:
        head += block.content
        head += "\n"
        break
      case SWIFT_BODY:
        body += block.content
        break;
      default:
        body += "\n\tresponse.appendBody(string: \n\"\"\"\n\(block.content)\n\"\"\"\n)\n"
      }
    }
    let page = """
    \(head)
    func \(handlerName)(data: [String:Any]) throws -> RequestHandler { return {
    request, response in
    \(body)
    response.completed()
    }
    }\n
    """
    try page.write(to: URL(fileURLWithPath: targetPath), atomically: true, encoding: .utf8)
  }
}

