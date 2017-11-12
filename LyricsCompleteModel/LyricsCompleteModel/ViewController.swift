//
//  ViewController.swift
//  LyricsCompleteModel
//
//  Created by MonkeySolution on 11/1/17.
//  Copyright © 2017 MonkeySolution. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
var musicPlayer: AVAudioPlayer?
class ViewController: UIViewController {
    @IBOutlet weak var lblBottom: UILabel!
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var playerView: UIView!
   
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBAction func btnStartClicked(_ sender: UIButton) {
//
        let player = AVPlayer.init(url: Bundle.main.url(forResource: "video", withExtension: "m4v")!)
        let playerLayer = AVPlayerLayer.init(player: player)
        playerLayer.frame = self.playerView.bounds
        self.playerView.layer.addSublayer(playerLayer)
        player.play()
        playSound()
        lyrics.startShowing()
        self.lblTop.sizeToFit()
        self.lblBottom.sizeToFit()
        self.lblTop.frame.origin.x = (self.topView.bounds.size.width - self.lblTop.bounds.size.width)/2
        self.lblTop.frame.size.height = self.topView.bounds.size.height
        self.lblBottom.frame.origin.x = (self.bottomView.bounds.size.width - self.lblBottom.bounds.size.width)/2
        self.lblBottom.frame.size.height = self.bottomView.bounds.size.height
    }
    var lyrics = Lyrics()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStrok()
        lyricsSetup()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func lyricsSetup(){
    lyrics.configuration = LyricsConfig.shared
        lyrics.setLyrics(from: Bundle.main.url(forResource: "subtitle", withExtension: "json")!)
        lyrics.configuration!.topView = topView
        lyrics.configuration!.bottomView = bottomView
        lyrics.configuration!.topLabel = lblTop
        lyrics.configuration!.bottomLabel = lblBottom
        //lyrics.configuration?.showSubtitleTextColor = UIColor.red
        //lyrics.configuration?.defaultSubtitleTextColor = UIColor.black
        lyrics.configuration!.controller = self
    }

    func setStrok(){
        
        
        let strokeTextAttributes = [
            NSAttributedStringKey.strokeColor : UIColor.green,
            NSAttributedStringKey.foregroundColor : UIColor.black,
            NSAttributedStringKey.strokeWidth : -3.0,
            NSAttributedStringKey.font : UIFont.init(name: "BYekan", size: 18)!
            ] as [NSAttributedStringKey : Any] as [NSAttributedStringKey : Any]
        self.lblTop.attributedText = NSAttributedString(string: "salam" , attributes: strokeTextAttributes)
         self.lblBottom.attributedText = NSAttributedString(string: "salam" , attributes: strokeTextAttributes)
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "music", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            musicPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = musicPlayer else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

