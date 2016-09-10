//
//  ViewController.swift
//  PiPHack
//
//  Created by Stephen Radford on 09/09/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Cocoa
import AVFoundation
import AVKit

class ViewController: NSViewController {
    
    @IBOutlet weak var playerView: AVPlayerView!

    /// Create a new PIPViewController instance, set the delegate to self and set the aspect ratio of the video to 16:9
    lazy var pip: PIPViewController! = {
        let pip = PIPViewController()!
        pip.delegate = self
        pip.aspectRatio = CGSize(width: 16, height: 9)
        pip.userCanResize = false
        
        // These replacement properties are used to animate between the window and PIP
        pip.replacementWindow = self.view.window
        pip.replacementRect = self.view.bounds
        
        return pip
    }()
    
    /// Our AVPlayer instance
    let player = AVPlayer(url: URL(string: "http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4")!)
    
    /// Whether the pipIsActive or not
    var pipIsActive = false
    
    var window: NSWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.player = player
    }
    
    override func viewDidAppear() {
        openPIP()
    }
    
    /// Displays the current view controller in picture in picture and sets the play button to be true.
    /// We added a pipIsActive flag here because it seems to get called twice. If the view controller has already presented then we'll get a crash from PIPViewController.
    /// We also keep an instance of the current view so when the PIPPanel closes we can return it back to its original state.
    func openPIP() {
        if !pipIsActive {
            pip.presentAsPicture(inPicture: self)
            pip.setPlaying(true)
            pipIsActive = true
        }
    }
    
}


// MARK: - PIPViewControllerDelegate

extension ViewController: PIPViewControllerDelegate {
    
    /// Called when the PIPPanel closes
    func pipDidClose(_ pip: PIPViewController!) {
        print("Panel closed")
    }
    
    /// Called when the PIPPanel stops playing
    func pipActionStop(_ pip: PIPViewController!) {
        print("Stopped")
    }
    
    /// Called when the play button in the PIPPanel is clicked
    func pipActionPlay(_ pip: PIPViewController!) {
        player.play()
    }
    
    /// Called when the pause button in the PIPPanel is clicked
    func pipActionPause(_ pip: PIPViewController!) {
        player.pause()
    }
    
}

