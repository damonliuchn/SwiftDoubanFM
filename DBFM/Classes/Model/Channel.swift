import Foundation
import ObjectMapper

class Channel: Mappable {
    var name: String?
    var channelId: String?

    required init?(_ map: Map) {

    }

    func mapping(map: Map) {
        name <- map["name"]
        channelId <- map["channel_id"]
    }

}
