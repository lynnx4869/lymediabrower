//
//  VideoController.swift
//  lymediabrower
//
//  Created by xianing on 2017/11/16.
//  Copyright © 2017年 czcg. All rights reserved.
//

import UIKit
import IJKMediaFramework

class VideoController: UIViewController {
    
    var file: FileModel!
    
    fileprivate var iplayer: IJKMediaPlayback!
    fileprivate let controlBg = UIView()
    fileprivate let control = VideoControl()
    
    fileprivate var isFullscreenModel: Bool = false {
        didSet {
            if oldValue == isFullscreenModel { return }
            
            if isFullscreenModel {
                iplayer.view.snp.remakeConstraints { (make) in
                    make.edges.equalTo(view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                }
                
                controlBg.snp.remakeConstraints { (make) in
                    make.edges.equalTo(view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                }
                
                control.snp.remakeConstraints { (make) in
                    var left: CGFloat = 0
                    var right: CGFloat = 0
                    if Consts.iPhoneX() {
                        left = 44.0
                        right = 44.0
                    }
                    make.edges.equalTo(controlBg).inset(UIEdgeInsets(top: 20, left: left, bottom: 20, right: right))
                }
            } else {
                iplayer.view.snp.remakeConstraints { (make) in
                    make.top.equalTo(view.snp.top).offset(0)
                    make.left.equalTo(view.snp.left).offset(0)
                    make.right.equalTo(view.snp.right).offset(0)
                    make.height.equalTo(self.iplayer.view.snp.width).multipliedBy(9.0/16.0).priority(750)
                }
                
                controlBg.snp.remakeConstraints { (make) in
                    make.top.equalTo(view.snp.top).offset(0)
                    make.left.equalTo(view.snp.left).offset(0)
                    make.right.equalTo(view.snp.right).offset(0)
                    make.height.equalTo(controlBg.snp.width).multipliedBy(9.0/16.0).priority(750)
                }
                
                control.snp.remakeConstraints { (make) in
                    let top = UIApplication.shared.statusBarFrame.height
                    make.edges.equalTo(controlBg).inset(UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0))
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
        let urlString = (Consts.rootUrl() + file.playPath).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: urlString)
        
        IJKFFMoviePlayerController.setLogReport(false)
        IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_ERROR)
        IJKFFMoviePlayerController.checkIfFFmpegVersionMatch(true)
        
        let options = IJKFFOptions.byDefault()
        
        iplayer = IJKFFMoviePlayerController(contentURL: url, with: options)
        iplayer.scalingMode = .aspectFit
        iplayer.shouldAutoplay = true
        
        view.addSubview(iplayer.view)
        iplayer.view.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(0)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
            make.height.equalTo(self.iplayer.view.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        
        controlBg.backgroundColor = .clear
        view.addSubview(controlBg)
        controlBg.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(0)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
            make.height.equalTo(controlBg.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        
        control.delegatePlayer = iplayer
        control.isControlHidden = false
        controlBg.addSubview(control)
        control.snp.makeConstraints { (make) in
            let top = UIApplication.shared.statusBarFrame.height
            make.edges.equalTo(controlBg).inset(UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0))
        }
    }
    
    fileprivate func setupControl() {
        control.backBtn.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        control.videoLabel.text = file.itemName
        
        control.playBtn.addTarget(self, action: #selector(playAction(_:)), for: .touchUpInside)
        control.fullBtn.addTarget(self, action: #selector(fullAction(_:)), for: .touchUpInside)
        control.videoProgress.addTarget(self, action: #selector(changeProgress(_:)), for: .valueChanged)
        
        //单击手势
        let stap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(_:)))
        stap.numberOfTapsRequired = 1
        stap.numberOfTouchesRequired = 1
        control.centerView.addGestureRecognizer(stap)
        
        //双击手势
        let dtap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(_:)))
        dtap.numberOfTapsRequired = 2
        dtap.numberOfTouchesRequired = 1
        control.centerView.addGestureRecognizer(dtap)
        
        //清扫手势
        let uswipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        uswipe.direction = .up
        uswipe.numberOfTouchesRequired = 1
        control.centerView.addGestureRecognizer(uswipe)
        
        let dswipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        dswipe.direction = .down
        dswipe.numberOfTouchesRequired = 1
        control.centerView.addGestureRecognizer(dswipe)
        
        //缩放手势
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
        control.centerView.addGestureRecognizer(pinch)
        
        //拖动手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        control.centerView.addGestureRecognizer(pan)
        
        stap.require(toFail: dtap)
        pan.require(toFail: uswipe)
        pan.require(toFail: dswipe)
    }
    
    fileprivate func setupNotifications() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationHandler(_:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mediaPlayerStateChanged(_:)),
                                               name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange,
                                               object: iplayer)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
    
    //MARK: - Views
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        iplayer.prepareToPlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        iplayer.shutdown()
    }
    
    //MARK: - Events
    @objc fileprivate func backAction(_ sender: UIButton) {
        if isFullscreenModel {
            forceChangeOrientation(orientation: .portrait)
        } else {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.removeObserver(self)
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc fileprivate func playAction(_ sender: UIButton) {
        if iplayer.isPlaying() {
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
        iplayer.currentPlaybackTime = TimeInterval(progress)
        control.refreshMediaControl()
    }
    
    //MARK: - Touch Events
    @objc fileprivate func singleTapAction(_ sender: UITapGestureRecognizer) {
        control.isControlHidden = !control.isControlHidden
    }
    
    @objc fileprivate func doubleTapAction(_ sender: UITapGestureRecognizer) {
        if iplayer.isPlaying() {
            iplayer.pause()
        } else {
            iplayer.play()
        }
    }
    
    fileprivate var volumeView = MPVolumeView()
    fileprivate var _volumeSlider: UISlider!
    fileprivate func volumeSlider() -> UISlider {
        if _volumeSlider == nil {
            for view in volumeView.subviews {
                if (view.superclass?.isSubclass(of: UISlider.classForCoder()))! {
                    _volumeSlider = view as! UISlider
                }
            }
        }
        return _volumeSlider
    }
    
    @objc fileprivate func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            volumeSlider().value += 0.1
        }
        
        if sender.direction == .down {
            volumeSlider().value -= 0.1
        }
    }
    
    fileprivate var pinchScale: CGFloat = 0.0
    @objc fileprivate func pinchAction(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            pinchScale = sender.scale
        }
        
        if sender.state == .ended {
            if sender.scale > pinchScale {
                if !isFullscreenModel {
                    forceChangeOrientation(orientation: .landscapeRight)
                }
            } else {
                if isFullscreenModel {
                    forceChangeOrientation(orientation: .portrait)
                }
            }
            
            pinchScale = 0.0
        }
        
        if sender.state == .cancelled || sender.state == .failed {
            pinchScale = 0.0
        }
    }
    
    
    fileprivate var panNowTime: TimeInterval = 0.0
    fileprivate var panStartPt: CGPoint!
    
    @objc fileprivate func panAction(_ sender: UIPanGestureRecognizer) {
        if isFullscreenModel {
            if sender.state == .began {
                panNowTime = iplayer.currentPlaybackTime
                panStartPt = sender.translation(in: control.centerView)
            }
            
            if sender.state == .changed {
                let panEndPt = sender.translation(in: control.centerView)
                let panOffset = panEndPt.x - panStartPt.x
                
                let fullTime = iplayer.duration
                let width = control.centerView.bounds.width
                let offsetTime = panNowTime + fullTime * TimeInterval(panOffset/width)
                iplayer.currentPlaybackTime = offsetTime
                control.refreshMediaControl()
            }
            
            if sender.state == .ended {
                panNowTime = 0.0
                panStartPt = nil
            }
            
            if sender.state == .cancelled || sender.state == .failed {
                iplayer.currentPlaybackTime = panNowTime
                control.refreshMediaControl()
                
                panNowTime = 0.0
                panStartPt = nil
            }
        }
    }
    
    //MARK: - Notifications
    @objc fileprivate func orientationHandler(_ noti: Notification) {
        if UIDevice.current.orientation.isLandscape {
            isFullscreenModel = true
        } else {
            isFullscreenModel = false
        }
    }
    
    //MARK: - VLCMediaPlayerDelegate
    @objc func mediaPlayerStateChanged(_ noti: Notification) {
        if iplayer.playbackState == .playing {
            control.playBtn.setImage(UIImage(named: "pause"), for: .normal)
        } else if iplayer.playbackState == .paused  {
            control.playBtn.setImage(UIImage(named: "play"), for: .normal)
        } else if iplayer.playbackState == .stopped {
            iplayer.stop()
            control.playBtn.setImage(UIImage(named: "play"), for: .normal)
            control.videoProgress.value = 1.0
        }
    }
    
    //MARK: - Utils
    fileprivate func forceChangeOrientation(orientation: UIInterfaceOrientation) {
        let orientationTarget = NSNumber(value:orientation.rawValue)
        UIDevice.current.setValue(orientationTarget, forKey: "orientation")
    }
    
}
