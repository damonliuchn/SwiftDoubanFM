import UIKit

protocol HttpProtocol{
    func didRecieveResults(results:NSDictionary)
}

class HttpController:NSObject{
    
    func onSearch(url:String,delegate:HttpProtocol){
        var nsUrl:NSURL=NSURL(string:url)!
        var request:NSURLRequest=NSURLRequest(URL:nsUrl)
        NSURLConnection.sendAsynchronousRequest(
            request,
            queue: NSOperationQueue.mainQueue(),
            completionHandler: {
                (response:NSURLResponse!,data:NSData!,error:NSError!)->Void in
                var jsonResult:NSDictionary=NSJSONSerialization.JSONObjectWithData(
                    data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    as! NSDictionary
                delegate.didRecieveResults(jsonResult)
            }
        )
    }
}
