import UIKit

protocol ChannelControllerListener{
    //回调方法，将频道id传回到代理中
    func onChannelControllerChangeChannel(channelId:String)
}

class ChannelController: UIViewController {
    //频道列表tableview组件
    @IBOutlet weak var tv: UITableView!
    var channels: [Channel] = []
    //申明代理
    var listener:ChannelControllerListener?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0.8
    }

    //配置tableview数据的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }

    //配置cell的数据
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var channel = channels[indexPath.row]
        //可选变量里的必存值 可以 转换为 普通变量
        let cell = tv.dequeueReusableCellWithIdentifier("channel")! as UITableViewCell
        //设置cell的标题
        cell.textLabel?.text = "\(channel.name!)"
        return cell
    }

    //选中了具体的频道
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var channel = channels[indexPath.row]
        listener?.onChannelControllerChangeChannel(channel.channelId!)
        //关闭当前界面
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
