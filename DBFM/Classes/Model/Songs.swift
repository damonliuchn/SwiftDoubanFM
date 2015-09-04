import Foundation
import ObjectMapper

class Songs: Mappable {
    var songs: [Song] = []

    required init?(_ map: Map) {

    }

    public init() {

    }

    func mapping(map: Map) {
        songs <- map["song"]
    }
}
