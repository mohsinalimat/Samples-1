//
//  PlayerView.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/20/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit
import AVFoundation

let NC = NotificationCenter.default

class PlayerView: UIView {
    
    enum PlaybackState: Int {
        case paused, playing
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    let player = AVPlayer()
    
    var url: URL? {
        get { return player.url }
        set {
            guard let newValue = newValue, newValue != url else { return }
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let item = AVPlayerItem(url: newValue)
                DispatchQueue.main.async {
                    self?.setupPlayerItem(item)
                }
            }
        }
    }
    
    var playbackState: PlaybackState = .paused {
        didSet {
            playbackStateChanged?(oldValue)
        }
    }
    
    var loop: Bool {
        get { return player.actionAtItemEnd == .none }
        set { player.actionAtItemEnd = (newValue ? .none : .pause) }
    }
    
    var startTime: CMTime = kCMTimeZero
    var endTime: CMTime = kCMTimeIndefinite
    
    var playbackStateChanged: ((PlaybackState) -> ())?
    
    var playerReady: (() -> ())?
    var playerPlaybackWillStart: (() -> ())?
    
    fileprivate var timeObserver: Any?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        playerLayer.player = player
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        player.actionAtItemEnd = .none
    }
    
    deinit {
        setupPlayerItem(nil)
    }
    
    override class var layerClass : AnyClass {
        return AVPlayerLayer.self
    }
    
    // MARK:
    
    fileprivate func setupPlayerItem(_ playerItem: AVPlayerItem?) {
        if let playerItem = playerItem {
            NC.addObserver(self, selector: #selector(applicationWillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
            NC.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
            NC.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
            NC.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            addObserver(self, forKeyPath: #keyPath(player.currentItem.playbackLikelyToKeepUp), options: .new, context: nil)
            addObserver(self, forKeyPath: #keyPath(playerLayer.readyForDisplay), options: .new, context: nil)
//            timeObserver = player.addPeriodicTimeObserverForInterval(CMTimeMakeWithSeconds(1, 60000), queue: dispatch_get_main_queue()) { [weak self] interval in
//                self?.timeChanged?(interval)
//            }
            if !CMTIME_IS_INDEFINITE(endTime) {
                timeObserver = player.addBoundaryTimeObserver(forTimes: [NSValue(time: endTime)], queue: .main) { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.player.seek(to: strongSelf.startTime)
                }
            }
        } else if player.currentItem != nil {
            NC.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
            NC.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
            NC.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
            NC.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            removeObserver(self, forKeyPath: #keyPath(player.currentItem.playbackLikelyToKeepUp), context: nil)
            removeObserver(self, forKeyPath: #keyPath(playerLayer.readyForDisplay), context: nil)
            if let timeObserver = timeObserver { player.removeTimeObserver(timeObserver) }
        }
        
        player.replaceCurrentItem(with: playerItem)
    }
    
    // MARK:
    
    func playFromBeginning() {
        player.seek(to: startTime)
        playFromCurrentTime()
    }
    
    func playFromCurrentTime() {
        guard playbackState != .playing else { return }
        playbackState = .playing
        player.play()
    }
    
    func pause() {
        guard playbackState != .paused else { return }
        playbackState = .paused
        player.pause()
    }
    
    func reset() {
        playbackState = .paused
        setupPlayerItem(nil)
    }
    
}

// MARK: -
extension PlayerView {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print("\(keyPath) -> \(change)")
        if keyPath == #keyPath(player.currentItem.playbackLikelyToKeepUp) {
            let isPlaybackLikelyToKeepUp = (change?[NSKeyValueChangeKey.newKey] as? NSNumber)?.boolValue ?? false
            if isPlaybackLikelyToKeepUp && playbackState == .playing {
                playerPlaybackWillStart?()
                playFromCurrentTime()
            }
        } else if keyPath == #keyPath(playerLayer.readyForDisplay) {
            playerReady?()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}

// MARK: -
extension PlayerView {
    
    func playerItemDidPlayToEndTime(_ notification: Notification) {
        if player.actionAtItemEnd == .none {
            player.seek(to: startTime)
        } else {
            pause()
        }
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        if playbackState == .playing {
            pause()
        }
    }
    
    func applicationDidEnterBackground(_ notification: Notification) {
        if playbackState == .playing {
            pause()
        }
    }
    
    func applicationWillEnterForeground(_ notification: Notification) {
        if playbackState == .paused {
            playFromCurrentTime()
        }
    }
    
}

// MARK: -
extension AVPlayer {
    
    var url: URL? { return (currentItem?.asset as? AVURLAsset)?.url }
    
}
