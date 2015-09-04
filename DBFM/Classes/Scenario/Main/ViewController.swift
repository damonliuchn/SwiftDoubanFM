import UIKit
import Kingfisher
import MediaPlayer

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HttpSongProtocol, HttpChannelProtocol, ChannelControllerListener {
    //EkoImage组件，歌曲封面
    @IBOutlet weak var iv: EkoImage!
    //歌曲列表
    @IBOutlet weak var tv: UITableView!
    //背景
    @IBOutlet weak var bg: UIImageView!

    var channels: [Channel] = []
    var songs: [Song] = []
    var httpManager: HTTPUtil = HTTPUtil()
    //申明一个媒体播放器的实例
    var audioPlayer: MPMoviePlayerController = MPMoviePlayerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        iv.onRotation()
        //设置背景模糊
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        bg.addSubview(blurView)

        //类似于Adapter
        tv.dataSource = self
        tv.delegate = self

        //获取频道为0歌曲数据
//        var httpSongProtocol: HttpSongProtocol = {
//
//            final class SomethingClass: HttpSongProtocol {
//                func didRecieveSongs(results: Songs) {
//                    ViewController..songs = results.songs
//                    ViewController.self().tv.reloadData()
//                }
//            }
//
//            return SomethingClass(self)
//        }()
        httpManager.getSongs("https://douban.fm/j/mine/playlist?type=n&channel=255&from=mainsite", delegate: SomethingClass(name: self))
        //获取频道数据
        httpManager.getChannels("https://www.douban.com/j/app/radio/channels", delegate: self)

        //让tableView背景透明
        tv.backgroundColor = UIColor.clearColor()
    }

    class SomethingClass: HttpSongProtocol {
        var name: ViewController
        init(name: ViewController) {
            self.name = name
        }

        func didRecieveSongs(results: Songs) {
            name.songs = results.songs
            name.tv.reloadData()
            let myPath = NSIndexPath(forRow: 0, inSection: 0)
            name.tv.selectRowAtIndexPath(myPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
//            name.tableView(tableView: nil, didSelectRowAtIndexPath: myPath )
            name.clickRow(myPath)
        }
    }

    //类似于Adapter里的getCount
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    //类似于Adapter里的getView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("douban") as UITableViewCell!
        //让cell背景透明
        cell.backgroundColor = UIColor.clearColor()
        //设置cell的标题
        var song = songs[indexPath.row]
        cell.textLabel?.text = "\(song.title!)"
        cell.detailTextLabel?.text = "\(song.albumTitle!)"
        //设置缩略图
        cell.imageView?.kf_setImageWithURL(NSURL(string: "\(song.picture!)")!, placeholderImage: UIImage(named: "thumb"))
        return cell
    }

    //选中了具体的歌曲
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        clickRow(indexPath)
    }

    //选中了具体的歌曲
    func clickRow(indexPath: NSIndexPath) {
        //设置cell的标题
        var song = songs[indexPath.row]
        bg.kf_setImageWithURL(NSURL(string: "\(song.picture!)")!, placeholderImage: UIImage(named: "thumb"))
        iv.kf_setImageWithURL(NSURL(string: "\(song.picture!)")!, placeholderImage: UIImage(named: "thumb"))
        playAudio(song.url!)
    }

    //播放音乐的方法
    func playAudio(url: String) {
        self.audioPlayer.stop()
        self.audioPlayer.contentURL = NSURL(string: url)
        print(url)
        self.audioPlayer.play()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didRecieveSongs(results: Songs) {
        songs = results.songs
        self.tv.reloadData()
    }

    func didRecieveChannels(results: Channels) {
        channels = results.channels
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //获取跳转目标
        var channelC: ChannelController = segue.destinationViewController as! ChannelController
        //设置代理
        channelC.listener = self
        //传输频道列表数据
        channelC.channels = self.channels
    }

    func onChannelControllerChangeChannel(channelId: String) {
        httpManager.getSongs("https://douban.fm/j/mine/playlist?type=n&channel=\(channelId)&from=mainsite", delegate: self)
    }

}

