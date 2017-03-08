import UIKit

protocol ChannelControllerListener{
    //回调方法，将频道id传回到代理中
    func onChannelControllerChangeChannel(_ channelId:String)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }

    //配置cell的数据
    func tableView(_ tableView: UITableView, _  indexPath: IndexPath) -> UITableViewCell {
        let channel = channels[(indexPath as NSIndexPath).row]
        //可选变量里的必存值 可以 转换为 普通变量
        let cell = tv.dequeueReusableCell(withIdentifier: "channel")! as UITableViewCell
        //设置cell的标题
        cell.textLabel?.text = "\(channel.name!)"
        self.tableView(tableView,  indexPath)
        return cell
    }


    //选中了具体的频道
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let channel = channels[(indexPath as NSIndexPath).row]
        listener?.onChannelControllerChangeChannel(channel.channelId!)
        //关闭当前界面
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
