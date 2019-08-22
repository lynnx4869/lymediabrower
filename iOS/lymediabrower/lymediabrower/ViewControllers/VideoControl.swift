//
//  VideoControl.swift
//  lymediabrower
//
//  Created by xianing on 2017/11/16.
//  Copyright © 2017年 czcg. All rights reserved.
//

import UIKit
import SnapKit
import IJKMediaFramework

class VideoControl: UIView {
    
    var delegatePlayer: IJKMediaPlayback!
    
    var isControlHidden: Bool = false {
        didSet {
            topView.isHidden = isControlHidden
            bottomView.isHidden = isControlHidden
            
            if !isControlHidden {
                refreshMediaControl()
            }
        }
    }
    
    let topView = UIView()
    let centerView = UIView()
    let bottomView = UIView()
    
    let backBtn = UIButton(type: .custom)
    let videoLabel = UILabel()
    
    let playBtn = UIButton(type: .custom)
    let fullBtn = UIButton(type: .custom)
    let progressTime = UILabel()
    let fullTime = UILabel()
    let videoProgress = UISlider()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createViews() {
        topView.backgroundColor = .clear
        centerView.backgroundColor = .clear
        bottomView.backgroundColor = .clear
        
        centerView.isUserInteractionEnabled = true
        centerView.isMultipleTouchEnabled = true
        
        addSubview(topView)
        addSubview(centerView)
        addSubview(bottomView)
        
        topView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(0)
            make.right.equalTo(self.snp.right).offset(0)
            make.top.equalTo(self.snp.top).offset(0)
            make.bottom.equalTo(centerView.snp.top).offset(0)
            make.height.equalTo(30)
        }
        centerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(0)
            make.right.equalTo(self.snp.right).offset(0)
            make.top.equalTo(topView.snp.bottom).offset(0)
            make.bottom.equalTo(bottomView.snp.top).offset(0)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(0)
            make.right.equalTo(self.snp.right).offset(0)
            make.top.equalTo(centerView.snp.bottom).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(0)
            make.height.equalTo(40)
        }
        
        createTopViews()
        createBottomViews()
    }
    
    fileprivate func createTopViews() {
        backBtn.setImage(UIImage(named: "back"), for: .normal)
        topView.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(topView.snp.left).offset(5)
            make.top.equalTo(topView.snp.top).offset(2)
            make.bottom.equalTo(topView.snp.bottom).offset(-2)
            make.height.equalTo(backBtn.snp.width).multipliedBy(1)
        }
        
        videoLabel.font = UIFont.systemFont(ofSize: 15)
        videoLabel.textColor = .white
        topView.addSubview(videoLabel)
        videoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backBtn.snp.right).offset(5)
            make.right.greaterThanOrEqualTo(topView.snp.right).offset(-10)
            make.top.equalTo(topView.snp.top).offset(5)
            make.bottom.equalTo(topView.snp.bottom).offset(-5)
        }
    }
    
    fileprivate func createBottomViews() {
        playBtn.setImage(UIImage(named: "play"), for: .normal)
        bottomView.addSubview(playBtn)
        
        fullBtn.setImage(UIImage(named: "full"), for: .normal)
        bottomView.addSubview(fullBtn)
        
        progressTime.font = UIFont.systemFont(ofSize: 12)
        progressTime.textColor = .white
        progressTime.textAlignment = .center
        bottomView.addSubview(progressTime)
        
        fullTime.font = UIFont.systemFont(ofSize: 12)
        fullTime.textColor = .white
        fullTime.textAlignment = .center
        bottomView.addSubview(fullTime)
        
        videoProgress.minimumTrackTintColor = Consts.MainColor
        videoProgress.setThumbImage(UIImage(named: "slider-btn"), for: .normal)
        bottomView.addSubview(videoProgress)
        
        playBtn.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView.snp.left).offset(5)
            make.top.equalTo(bottomView.snp.top).offset(5)
            make.bottom.equalTo(bottomView.snp.bottom).offset(-5)
            make.height.equalTo(playBtn.snp.width).multipliedBy(1)
        }
        
        progressTime.snp.makeConstraints { (make) in
            make.left.equalTo(playBtn.snp.right).offset(5)
            make.top.equalTo(bottomView.snp.top).offset(5)
            make.bottom.equalTo(bottomView.snp.bottom).offset(-5)
            make.width.equalTo(50)
        }
        
        fullTime.snp.makeConstraints { (make) in
            make.right.equalTo(fullBtn.snp.left).offset(-5)
            make.top.equalTo(bottomView.snp.top).offset(5)
            make.bottom.equalTo(bottomView.snp.bottom).offset(-5)
            make.width.equalTo(50)
        }
        
        fullBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bottomView.snp.right).offset(-5)
            make.top.equalTo(bottomView.snp.top).offset(5)
            make.bottom.equalTo(bottomView.snp.bottom).offset(-5)
            make.height.equalTo(fullBtn.snp.width).multipliedBy(1)
        }
        
        videoProgress.snp.makeConstraints { (make) in
            make.left.equalTo(progressTime.snp.right).offset(5)
            make.right.equalTo(fullTime.snp.left).offset(-5)
            make.centerY.equalTo(bottomView.snp.centerY)
        }
    }
    
    @objc func refreshMediaControl() {
        let duration = Float(delegatePlayer.duration)
        let position = Float(delegatePlayer.currentPlaybackTime)
        if duration > 0 {
            videoProgress.maximumValue = duration
            videoProgress.value = position
            fullTime.text = formatTime(time: duration)
            progressTime.text = formatTime(time: position)
        } else {
            videoProgress.maximumValue = 1.0
            videoProgress.value = 0.0
            fullTime.text = formatTime(time: 0)
            progressTime.text = formatTime(time: 0)
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(refreshMediaControl),
                                               object: nil)
        if !isControlHidden {
            perform(#selector(refreshMediaControl),
                    with: nil,
                    afterDelay: 0.5)
        }
    }
    
    fileprivate func formatTime(time: Float) -> String {
        let zone = Date(timeIntervalSince1970: 0)
        let now = Date(timeIntervalSince1970: TimeInterval(time))
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: zone, to: now)
        
        if dateComponents.hour == 0 {
            return String(format: "%.2d:%.2d", arguments: [dateComponents.minute!, dateComponents.second!])
        } else {
            return String(format: "%.2d:%.2d:%.2d", arguments: [dateComponents.hour!, dateComponents.minute!, dateComponents.second!])
        }
    }
    
}
