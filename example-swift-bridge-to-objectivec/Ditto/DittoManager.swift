
import Foundation
import DittoSwift


// See the documentation for more info or contact us!
/// Documentation : https://docs.ditto.live/
/// Email : support@ditto.live


@objcMembers
final class DittoManager: NSObject {

    static let shared = DittoManager()
    private var ditto: Ditto!

    private var subscriptions = [DittoSubscription]()
    private var liveQueries = [DittoLiveQuery]()

    private let appID = "<Insert your App ID>"
    private let onlineToken = "<Insert your token>"

    var flightID = "example-flight-id"

    private override init() {
        super.init()

        setupDitto()
    }

    private func setupDitto() {

        DittoLogger.minimumLogLevel = .verbose

        let identity = DittoIdentity.onlinePlayground(appID: appID, token: onlineToken)

        ditto = Ditto(identity: identity)
    }

    private func startSync() {
        do {
            try ditto.startSync()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    private func observeItems() {

        let query = ditto.store.collection("items-\(flightID)").findAll()

        subscriptions.append(query.subscribe())

        let queue = DispatchQueue.global(qos: .utility)

        liveQueries.append(query.observeLocal(deliverOn: queue) { docs, event in

            let items = docs.map { ItemDittoModel(doc: $0) }

            NotificationCenter.default.post(name: .Ditto.itemsUpdated, object: nil, userInfo: ["items": items])

        })
    }

}

// MARK: - Internal Access Properties / Methods

extension DittoManager {

    var dittoSDKVersion: String {
        return ditto.sdkVersion
    }

    func upsertItem(id: String, name: String) {

        let item: [String: Any?] = ["_id": id, "name": name]

        do {
            try ditto.store.collection("items").upsert(item)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
