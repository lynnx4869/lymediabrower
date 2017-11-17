//
//  VideoController.swift
//  lymediabrower
//
//  Created by xianing on 2017/11/16.
//  Copyright © 2017年 czcg. All rights reserved.
//

import UIKit

class VideoController: UIViewController, VLCMediaPlayerDelegate {
    
    var file: FileModel!
    
    fileprivate let playView = UIView()
    fileprivate var iplayer: VLCMediaPlayer!
    fileprivate var video: VLCMedia!
    fileprivate let control = VideoControl()
    
    fileprivate var isFullscreenModel: Bool! {
        didSet {
            if oldValue == isFullscreenModel { return }
            
            if isFullscreenModel {
                playView.snp.removeConstraints()
                playView.snp.makeConstraints { (make) in
                    make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                }
                
                control.snp.removeConstraints()
                control.snp.makeConstraints { (make) in
                    make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                }
            } else {
                playView.snp.removeConstraints()
                playView.snp.makeConstraints { (make) in
                    make.top.equalTo(self.view.snp.top).offset(0)
                    make.left.equalTo(self.view.snp.left).offset(0)
                    make.right.equalTo(self.view.snp.right).offset(0)
                    make.height.equalTo(playView.snp.width).multipliedBy(9.0/16.0).priority(750)
                }
                
                control.snp.removeConstraints()
                control.snp.makeConstraints { (make) in
                    make.top.equalTo(self.view.snp.top).offset(0)
                    make.left.equalTo(self.view.snp.left).offset(0)
                    make.right.equalTo(self.view.snp.right).offset(0)
                    make.height.equalTo(playView.snp.width).multipliedBy(9.0/16.0).priority(750)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        setupViews()
        setupControl()
        setupNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Init
    fileprivate func setupViews() {
        playView.backgroundColor = .black
        view.addSubview(playView)
        playView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.height.equalTo(playView.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        
        view.addSubview(control)
        control.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.height.equalTo(playView.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        
        let urlString = (Consts.rootUrl() + file.playPath).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        iplayer = VLCMediaPlayer()
        iplayer.drawable = playView
        iplayer.delegate = self
        video = VLCMedia(url: URL(string: urlString)!)
        iplayer.media = video
        
        isFullscreenModel = false
    }
    
    fileprivate func setupControl() {
        control.backBtn.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        control.videoLabel.text = file.itemName
        
        control.playBtn.addTarget(self, action: #selector(playAction(_:)), for: .touchUpInside)
        control.fullBtn.addTarget(self, action: #selector(fullAction(_:)), for: .touchUpInside)
        control.videoProgress.addTarget(self, action: #selector(changeProgress(_:)), for: .valueChanged)
        
        control.progressTime.text = formatTime(time: 0)
        control.fullTime.text = formatTime(time: 0)
    }
    
    fileprivate func setupNotifications() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationHandler(_:)),
                                               name: Notification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
    }
    
    //MARK: - Views
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        iplayer.play()
    }
    
    //MARK: - Events
    @objc fileprivate func backAction(_ sender: UIButton) {
        if isFullscreenModel {
            forceChangeOrientation(orientation: .portrait)
        } else {
            iplayer.stop()
            iplayer.drawable = nil
            iplayer.delegate = nil
            iplayer = nil
            
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.removeObserver(self)
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc fileprivate func playAction(_ sender: UIButton) {
        if iplayer.isPlaying {
            iplayer.pause()
        } else {
            iplayer.play()
        }
    }
    
    @objc fileprivate func fullAction(_ sender: UIButton) {
        if isFullscreenModel {
            forceChangeOrientation(orientation: .portrait)
        } else {
            forceChangeOrientation(orientation: .landscapeRight)
        }
    }
    
    @objc fileprivate func changeProgress(_ sender: UISlider) {
        let progress = sender.value
        let time = video.length.value.floatValue * progress
        
        iplayer.time = VLCTime(number: NSNumber(value: time))
        control.progressTime.text = formatTime(time: time)
    }
    
    //MARK: - Notifications
    @objc fileprivate func orientationHandler(_ noti: Notification) {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            isFullscreenModel = true
        } else {
            isFullscreenModel = false
        }
    }
    
    //MARK: - VLCMediaPlayerDelegate
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        if iplayer.state == .playing {
            control.playBtn.setImage(UIImage(named: "pause"), for: .normal)
        } else if iplayer.state == .paused  {
            control.playBtn.setImage(UIImage(named: "play"), for: .normal)
        } else if iplayer.state == .stopped {
            iplayer.stop()
            control.playBtn.setImage(UIImage(named: "play"), for: .normal)
            control.videoProgress.value = 1.0
        }
//        else if iplayer.state == .buffering {
//            control.playBtn.setImage(UIImage(named: "play"), for: .normal)
//        }
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        let progress = iplayer.time.value.floatValue / video.length.value.floatValue
        control.videoProgress.value = progress
        control.progressTime.text = formatTime(time: iplayer.time.value.floatValue)
        control.fullTime.text = formatTime(time: video.length.value.floatValue)
    }

    //MARK: - Utils
    fileprivate func forceChangeOrientation(orientation: UIInterfaceOrientation) {
        let orientationTarget = NSNumber(value:orientation.rawValue)
        UIDevice.current.setValue(orientationTarget, forKey: "orientation")
    }
    
    fileprivate func formatTime(time: Float) -> String {
        let zone = Date(timeIntervalSince1970: 0)
        let now = Date(timeIntervalSince1970: TimeInterval(time/1000))
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: zone, to: now)
        
        if dateComponents.hour == 0 {
            return supplementZero(time: dateComponents.minute!) + ":" + supplementZero(time: dateComponents.second!)
        } else {
            return supplementZero(time: dateComponents.hour!) + ":" + supplementZero(time: dateComponents.minute!) + ":" + supplementZero(time: dateComponents.second!)
        }
    }
    
    fileprivate func supplementZero(time: Int) -> String {
        if time < 10 {
            return "0" + String(time)
        } else {
            return String(time)
        }
    }
    
}
