//
//  GameViewController.swift
//  Shield Knight - The Cursed Artifact
//
//  Created by Claudio Silvestri on 21/03/22.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {

//    var AudioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "CurshieldKnight", ofType: "mp3")!)
//        AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
//        AudioPlayer.prepareToPlay()
//        AudioPlayer.numberOfLoops = -1
//        AudioPlayer.play()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "StartMenu") {
                // Set the scale mode to scale to fit the window
                if UIDevice.current.userInterfaceIdiom == .pad {
                    scene.scaleMode = .aspectFit
                }
                else
                {
                    scene.scaleMode = .aspectFill

                }
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
//            view.showsFPS = true
//            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
