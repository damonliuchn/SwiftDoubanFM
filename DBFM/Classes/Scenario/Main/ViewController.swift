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
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
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
        httpManager.getSongs(url: "https://douban.fm/j/mine/playlist?type=n&channel=255&from=mainsite", delegate: SomethingClass(name: self))
        //获取频道数据
        httpManager.getChannels(url: "https://www.douban.com/j/app/radio/channels", delegate: self)

        //让tableView背景透明
        tv.backgroundColor = UIColor.clear
    }

    class SomethingClass: HttpSongProtocol {
        var name: ViewController
        init(name: ViewController) {
            self.name = name
        }

        func didRecieveSongs(results: Songs) {
            name.songs = results.songs
            name.tv.reloadData()
            let myPath = IndexPath(row: 0, section: 0)
            name.tv.selectRow(at: myPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
//            name.tableView(tableView: nil, didSelectRowAtIndexPath: myPath )
            name.clickRow(myPath)
        }
    }

    //类似于Adapter里的getCount
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    //类似于Adapter里的getView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: "douban") as UITableViewCell!
        //让cell背景透明
        cell?.backgroundColor = UIColor.clear
        //设置cell的标题
        var song = songs[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = "\(song.title!)"
        cell?.detailTextLabel?.text = "\(song.albumTitle!)"
        //设置缩略图
        cell?.imageView?.kf.setImage(with:URL(string: "\(song.picture!)")!)
        return cell!
    }

    //选中了具体的歌曲
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickRow(indexPath)
    }

    //选中了具体的歌曲
    func clickRow(_ indexPath: IndexPath) {
        //设置cell的标题
        var song = songs[(indexPath as NSIndexPath).row]
        bg?.kf.setImage(with:URL(string: "\(song.picture!)")!)
        iv?.kf.setImage(with:URL(string: "\(song.picture!)")!)
        playAudio(song.url!)
    }

    //播放音乐的方法
    func playAudio(_ url: String) {
        self.audioPlayer.stop()
        self.audioPlayer.contentURL = URL(string: url)
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

    func didRecieveChannels(_ results: Channels) {
        channels = results.channels
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //获取跳转目标
        let channelC: ChannelController = segue.destination as! ChannelController
        //设置代理
        channelC.listener = self
        //传输频道列表数据
        channelC.channels = self.channels
    }

    func onChannelControllerChangeChannel(_ channelId: String) {
        httpManager.getSongs(url: "https://douban.fm/j/mine/playlist?type=n&channel=\(channelId)&from=mainsite", delegate: self)
    }

}

