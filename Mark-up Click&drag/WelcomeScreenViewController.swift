//
//  WelcomeScreenViewController.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 4/9/17.
//  Copyright © 2017 Pushbox, LLC'. All rights reserved.
//

import UIKit
import AVFoundation
class WelcomeScreenViewController: AudioViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 0.5, animations: {
            self.playBackgroundMusic(filename: "SSBAppintro.mp3")
        })
        

        // Do any additional setup after loading the view.
    }

    
    
    var backgroundMusicPlayer = AVAudioPlayer()
    
    func playBackgroundMusic(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: newURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
            backgroundMusicPlayer.volume = 0.2
        } catch let error as NSError {
            print(error.description)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.backgroundMusicPlayer.stop()
        self.audioPlayer.stop()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
