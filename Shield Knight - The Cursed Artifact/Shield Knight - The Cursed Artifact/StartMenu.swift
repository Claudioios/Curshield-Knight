//
//  StartMenu.swift
//  Shield Knight - The Cursed Artifact
//
//  Created by Claudio Silvestri on 22/03/22.
//



import SpriteKit
import GameplayKit
    
class StartMenu: SKScene {
    
    var StartButton: SKSpriteNode?
    var TextureButton : Bool = true
    
    override func sceneDidLoad() {

        self.backgroundColor = .black

        self.StartButton = self.childNode(withName: "TapToStart") as? SKSpriteNode

    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            self.touchDown(atPoint: touch.location(in: self))
        }
    }

    func touchDown(atPoint pos: CGPoint) {
        let nodes = self.nodes(at: pos)
        let transition = SKTransition.fade(withDuration: 1)

        let scene = SKScene(fileNamed: "GameScene")
        scene?.scaleMode = .aspectFill
        self.view?.presentScene(scene!,transition: transition)

        

        
    }

        override func didMove(to view: SKView) {
            
            let BlinkButton = SKAction.wait(forDuration: 0.5)
            let BlinkButtonAction = SKAction.run(
            {
                if (self.TextureButton == true)
                {
                    self.StartButton?.texture = SKTexture(imageNamed: "TapToStart")
                    self.TextureButton = false

                }
                else
                {
                    self.StartButton?.texture = SKTexture(imageNamed: "BlackStartButton")
                    self.TextureButton = true


                }
                    
            }
            )
            let SeqButton = SKAction.sequence([BlinkButton,BlinkButtonAction])
            let RepeatBlink = SKAction.repeatForever(SeqButton)
            run(RepeatBlink)
            
        }
}
