import Foundation
import ObjectMapper

class Song: Mappable {
    var title: String?
    var picture: String?
    var albumTitle: String?
    var url: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        title <- map["title"]
        picture <- map["picture"]
        albumTitle <- map["albumtitle"]
        url <- map["url"]
    }

}
