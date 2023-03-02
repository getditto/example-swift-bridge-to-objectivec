
import Foundation
import DittoSwift


@objcMembers
final class ItemDittoModel: NSObject {

    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    init(doc: DittoDocument) {
        id = doc.id.stringValue
        name = doc["name"].stringValue
    }
    
}
