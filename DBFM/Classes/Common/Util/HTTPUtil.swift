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

        Alamofire.request(url).responseJSON {
            response in
            print("sss")
            if let status = response.response?.statusCode {
                if (status >= 200 && status < 300) {
                    print("example success")
                    //to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! String
                        let channels = Mapper<Channels>().map(JSONString:JSON)
                        delegate?.didRecieveChannels(channels!)
                    }
                } else {
                    print("error with response status: \(status)")
                }
            }
            //let channels = Mapper<Channels>().map(response.result.value)
            //delegate?.didRecieveChannels(channels!)
        }
    }

    func getSongs(url: String, delegate: HttpSongProtocol) {
        Alamofire.request(url).responseJSON {
            response in
            //print(response.result.value)
            //let songs = Mapper<Songs>().map(response.result.value)
            //delegate.didRecieveSongs(songs!)
        }
    }

}

//定义http协议

protocol HttpChannelProtocol {
    //定义一个方法，接收一个参数：AnyObject
    func didRecieveChannels(_ results: Channels)
}

protocol HttpSongProtocol {
    func didRecieveSongs(results: Songs)
}
