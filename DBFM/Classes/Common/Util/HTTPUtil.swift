import UIKit
import Alamofire
import ObjectMapper

class HTTPUtil: NSObject {
    //接收网址，回调代理的方法传回数据
    func getChannels(url: String, delegate: HttpChannelProtocol?) {
//        Alamofire.request(.GET, url).responseJSON {
//            response in
//            switch response.result {
//            case .Success(let data):
//                self.delegate?.didRecieveResults(data)
//            case .Failure(let error):
//                print("Request failed with error: \(error)")
//            }
//        }

        Alamofire.request(.GET, url).responseString(completionHandler: {
            response in
            let channels = Mapper<Channels>().map(response.result.value)
            delegate?.didRecieveChannels(channels!)
        })
    }

    func getSongs(url: String, delegate: HttpSongProtocol) {
        Alamofire.request(.GET, url).responseString(completionHandler: {
            response in
            let songs = Mapper<Songs>().map(response.result.value)
            delegate.didRecieveSongs(songs!)
        })
    }
}

//定义http协议

protocol HttpChannelProtocol {
    //定义一个方法，接收一个参数：AnyObject
    func didRecieveChannels(results: Channels)
}

protocol HttpSongProtocol {
    func didRecieveSongs(results: Songs)
}
