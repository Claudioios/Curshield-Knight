//
//  GameScene.swift
//  Shield Knight - The Cursed Artifact
//
//  Created by Claudio Silvestri on 21/03/22.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
        
    private var GoblinEffect : SKEmitterNode?
    private var BatEffect : SKEmitterNode?
    
    private var SpawnAction = SKNode()
    
    private var PositionCounter = 0
    private var i = 0
    private var EnemyThatSpawned = 0
    private var Points : SKLabelNode?
    private var Score : Int = 0
    
    private var Hero : SKSpriteNode?
    private var Shield : SKSpriteNode?
    
    private var GoblinLeft : SKSpriteNode?
    private var GoblinRight : SKSpriteNode?

    private var GoblinLeftAttack: [SKTexture] = []
    private var GoblinRightAttack: [SKTexture] = []
    
    private var HeroWalk: [SKTexture] = []
//    private var BatFly: [SKTexture] = []

    private var GoblinLeftAttackGif: SKAction?
    private var GoblinRightAttackGif: SKAction?
    
    private var HeroWalkGif: SKAction?
//    private var BatFlyGif: SKAction?

    private var BatLeft : SKSpriteNode?
    private var BatUp : SKSpriteNode?
    private var BatRight : SKSpriteNode?
    
    private var ProjectileLeft : SKSpriteNode?
    private var ProjectileUp : SKSpriteNode?
    private var ProjectileRight : SKSpriteNode?

    private var SpawnedBatUp : Bool = false
    private var SpawnedBatLeft : Bool = false
    private var SpawnedBatRight : Bool = false
    private var SpawnedGoblinRight : Bool = false
    private var SpawnedGoblinLeft : Bool = false

    private var ShootUp : Bool = false
    private var ShootLeft : Bool = false
    private var ShootRight : Bool = false
    
    private var Invulnerability : Bool = false
    
    private var isSpawned : Bool = false
    
    private var IsGameOver : Bool = false
    private var BackgroundGameOver : SKSpriteNode?
    private var RetryButton : SKSpriteNode?
    private var GameOverLabel : SKSpriteNode?
    private var HighScoreGameOver : SKSpriteNode?
    private var PointsGameOver : SKLabelNode?
    
    private var SkyCloud1 : SKSpriteNode?
    private var SkyCloud2 : SKSpriteNode?
    private var Grass1 : SKSpriteNode?
    private var Grass2 : SKSpriteNode?
    private var Home1 : SKSpriteNode?
    private var Home2 : SKSpriteNode?
    private var Mount1 : SKSpriteNode?
    private var Mount2 : SKSpriteNode?
    private var Mountains1 : SKSpriteNode?
    private var Mountains2 : SKSpriteNode?
    private var Tree1 : SKSpriteNode?
    private var Tree2 : SKSpriteNode?
    
    private var HUD : SKSpriteNode?
    private var Life1 : SKSpriteNode?
    private var Life2 : SKSpriteNode?
    private var Life3 : SKSpriteNode?

    private var RandomSpawn : Int = 0
    private var Life : Int = 3
    private var BatUpLife : Int = 2
    
    private var AudioPlayer = AVAudioPlayer()
    
    func GoblinDeathEffect(GoblinPosition: CGPoint){
            GoblinEffect = SKEmitterNode(fileNamed: "GoblinDeath.sks")
            self.addChild(GoblinEffect!)
        GoblinEffect?.position = GoblinPosition
    }
    
    func BatDeathEffect(BatPosition: CGPoint){
            BatEffect = SKEmitterNode(fileNamed: "BatDeath.sks")
            self.addChild(BatEffect!)
            BatEffect?.position = BatPosition
    }
    
    func MoveRight(ShieldPositionCounter: Int){
        switch ShieldPositionCounter {

                    case 3:
                        Shield?.position = CGPoint(x: -35, y: -160)
                        Shield?.zRotation = 2.61799
                    case 2:
                        Shield?.position = CGPoint(x: 0, y: -150)
                        Shield?.zRotation = 1.5708
                    case 1:
                        Shield?.position = CGPoint(x: 35, y: -160)
                        Shield?.zRotation = 0.523599
                    case 0:
                        Shield?.position = CGPoint(x: 40, y: -182.5)
                        Shield?.zRotation = 0

                    default:
                        return
            }
    }
    
    func MoveLeft(ShieldPositionCounter: Int){
        switch ShieldPositionCounter {

                    case 1:
                        Shield?.position = CGPoint(x: 35, y: -160)
                        Shield?.zRotation = 0.523599
                    case 2:
                        Shield?.position = CGPoint(x: 0, y: -150)
                        Shield?.zRotation = 1.5708
                    case 3:
                        Shield?.position = CGPoint(x: -35, y: -160)
                        Shield?.zRotation = 2.61799
                    case 4:
                        Shield?.position = CGPoint(x: -40, y: -182.5)
                        Shield?.zRotation = 3.14159

                    default:
                        return
            }
    }
    func Invulnerability3sec(){
        Invulnerability = true
        Hero?.alpha = 0.0
        Shield?.alpha = 0.0
        
        let BlinkAcceso = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        let BlinkSpento = SKAction.fadeAlpha(to: 0.0, duration: 0.1)
        let BlinkAction = SKAction.sequence([BlinkSpento,BlinkAcceso])
        let RepeatAction = SKAction.repeat(BlinkAction, count: 10)
        Hero?.run(RepeatAction)
        Shield?.run(RepeatAction)
        
        let WaitInvulnerability = SKAction.wait(forDuration: 2.0)
                let UpdateInvulnerability = SKAction.run(
                {
                    self.Invulnerability = false
                }
                )
                let InvulnerabilityAction = SKAction.sequence([WaitInvulnerability,UpdateInvulnerability])
                run(InvulnerabilityAction)
    }
    
//    func BatUpEndlessFly(){
//        for i in 0...2 {
//            BatFly.append(SKTexture(imageNamed: "BatUp\(i)"));
//        }
//        BatFlyGif = SKAction.animate(with: BatFly, timePerFrame: 0.3)
//        BatUp?.run(SKAction.repeatForever(BatFlyGif!))
//    }
    
    func EndlessWalk(){
        for i in 0...3 {
            HeroWalk.append(SKTexture(imageNamed: "Hero\(i)"));
        }
        HeroWalkGif = SKAction.animate(with: HeroWalk, timePerFrame: 0.3)
        Hero?.run(SKAction.repeatForever(HeroWalkGif!))
    }
    
    func EndlessGoblinAttackLeft()
    {
        for i in 0...3 {
            GoblinLeftAttack.append(SKTexture(imageNamed: "GoblinLeftAttack\(i)"));
        }
        GoblinLeftAttackGif = SKAction.animate(with: GoblinLeftAttack, timePerFrame: 0.3)
        GoblinLeft?.run(SKAction.repeatForever(GoblinLeftAttackGif!))
    }
    func EndlessGoblinAttackRight()
    {
        for i in 0...3 {
            GoblinRightAttack.append(SKTexture(imageNamed: "GoblinRightAttack\(i)"));
        }
        GoblinRightAttackGif = SKAction.animate(with: GoblinRightAttack, timePerFrame: 0.3)
        GoblinRight?.run(SKAction.repeatForever(GoblinRightAttackGif!))
    }
    
    func SkyCloudParallax(){

        let moveLeft = SKAction.moveBy(x: -1334, y: 0, duration: 20)
        let moveReset = SKAction.moveBy(x: 1334, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        SkyCloud1?.run(moveForever)
        SkyCloud2?.run(moveForever)
        
    }
    
    func GrassParallax(){

        let moveLeft = SKAction.moveBy(x: -1334, y: 0, duration: 6)
        let moveReset = SKAction.moveBy(x: 1334, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        Grass1?.run(moveForever)
        Grass2?.run(moveForever)
        
    }
    
    func MountainsParallax(){

        let moveLeft = SKAction.moveBy(x: -1334, y: 0, duration: 10)
        let moveReset = SKAction.moveBy(x: 1334, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        Mountains1?.run(moveForever)
        Mountains2?.run(moveForever)
        
    }
    
    func MountParallax(){

        let moveLeft = SKAction.moveBy(x: -1334, y: 0, duration: 8)
        let moveReset = SKAction.moveBy(x: 1334, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        Mount1?.run(moveForever)
        Mount2?.run(moveForever)
        
    }
    
    func HomeParallax(){

        let moveLeft = SKAction.moveBy(x: -1334, y: 0, duration: 6)
        let moveReset = SKAction.moveBy(x: 1334, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        Home1?.run(moveForever)
        Home2?.run(moveForever)
        
    }
    
    func TreeParallax(){

        let moveLeft = SKAction.moveBy(x: -1334, y: 0, duration: 6)
        let moveReset = SKAction.moveBy(x: 1334, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        Tree1?.run(moveForever)
        Tree2?.run(moveForever)
        
    }
    
    func GameOver(){
        IsGameOver = true
        
//        Grass1?.isPaused = true
//        Grass2?.isPaused = true
//        Home1?.isPaused = true
//        Home2?.isPaused = true
//        Mount1?.isPaused = true
//        Mount2?.isPaused = true
//        Mountains1?.isPaused = true
//        Mountains2?.isPaused = true
//        Tree1?.isPaused = true
//        Tree2?.isPaused = true
//        Hero?.isPaused = true
//        GoblinRight?.isPaused = true
//        GoblinLeft?.isPaused = true
//        BatUp?.isPaused = true
        self.isPaused = true
        
        BackgroundGameOver?.isHidden = false
        BackgroundGameOver?.zPosition = 3
        BackgroundGameOver?.position = CGPoint(x: 0, y: 0)
        BackgroundGameOver?.size = CGSize(width: self.frame.width, height: self.frame.height)
        BackgroundGameOver?.alpha = 0.5
        
        GameOverLabel?.zPosition = 4
        GameOverLabel?.position = CGPoint(x: 0, y: 180)

        RetryButton?.zPosition = 4
        RetryButton?.position = CGPoint(x: 0, y: -180)

        HighScoreGameOver?.zPosition = 4
        HighScoreGameOver?.position = CGPoint(x: -160, y: 0)

        PointsGameOver?.zPosition = 4
        PointsGameOver?.position = CGPoint(x: 250, y: 0)
        PointsGameOver?.text = "\(Score)"
        
        
    }
    
    func DifficultyController (){
        switch EnemyThatSpawned {

                    case 0...1:
                        SpawnAction.speed = 1
                        print("Livello 1")
                    case 2...3:
                        SpawnAction.speed = 1.25
                        print("Livello 2")
                    case 4...6:
                        SpawnAction.speed = 1.65
                        print("Livello 3")
                    case 7...10:
                        SpawnAction.speed = 2.5
                        print("Livello 4")
                    case 11...18:
                        SpawnAction.speed = 5
                        print("Livello 5")
                    case 19...:
                        SpawnAction.speed = 10
                        print("Livello 6")

                    default:
                        return
            }
        EnemyThatSpawned = EnemyThatSpawned + 1
    }
    
    func NewScore(){
        if (IsGameOver == false)
        {
        Score = Score + 100
        Points?.text = "\(Score)"
        }
    }
    
    func BatShootLeft(){
        if (ShootLeft == false)
        {
            ProjectileLeft = SKSpriteNode(texture: SKTexture(imageNamed: "Projectile"), size: CGSize(width: 18, height: 18))
            ProjectileLeft?.isHidden = false
            ProjectileLeft?.name = "ProjectileLeft"
//            self.ProjectileLeft = self.childNode(withName: "ProjectileLeft") as? SKSpriteNode
            ProjectileLeft?.physicsBody = SKPhysicsBody(circleOfRadius: 18)
            ProjectileLeft?.physicsBody?.affectedByGravity = false
            ProjectileLeft?.physicsBody?.isDynamic = true
            ProjectileLeft?.position.y = (BatLeft?.position.y)!
            ProjectileLeft?.position.x = (BatLeft?.position.x)!
            addChild(ProjectileLeft!)
            ShootLeft = true
        }
        else
        {
            ProjectileLeft?.position.y = (ProjectileLeft?.position.y)! - 5
            ProjectileLeft?.position.x = (ProjectileLeft?.position.x)! + 9
        }
    }
    func BatShootUp(){
        if (ShootUp == false)
        {
            ProjectileUp = SKSpriteNode(texture: SKTexture(imageNamed: "Projectile"), size: CGSize(width: 18, height: 18))
            ProjectileUp?.isHidden = false
            ProjectileUp?.name = "ProjectileUp"
//            self.ProjectileUp = self.childNode(withName: "ProjectileUp") as? SKSpriteNode
            ProjectileUp?.physicsBody = SKPhysicsBody(circleOfRadius: 18)
            ProjectileUp?.physicsBody?.affectedByGravity = false
            ProjectileUp?.physicsBody?.isDynamic = true
            ProjectileUp?.position.y = (BatUp?.position.y)!
            ProjectileUp?.position.x = (BatUp?.position.x)!
            addChild(ProjectileUp!)
            ShootUp = true
        }
        else
        {
            ProjectileUp?.position.y = (ProjectileUp?.position.y)! - 5

        }
    }
    func BatShootRight(){
        if (ShootRight == false)
        {
            ProjectileRight = SKSpriteNode(texture: SKTexture(imageNamed: "Projectile"), size: CGSize(width: 18, height: 18))
            ProjectileRight?.name = "ProjectileRight"
            ProjectileRight?.isHidden = false
//            self.ProjectileRight = self.childNode(withName: "ProjectileRight") as? SKSpriteNode
            ProjectileRight?.physicsBody = SKPhysicsBody(circleOfRadius: 18)
            ProjectileRight?.physicsBody?.affectedByGravity = false
            ProjectileRight?.physicsBody?.isDynamic = true
            ProjectileRight?.position.y = (BatRight?.position.y)!
            ProjectileRight?.position.x = (BatRight?.position.x)!
            addChild(ProjectileRight!)
            ShootRight = true
        }
        else
        {
            ProjectileRight?.position.y = (ProjectileRight?.position.y)! - 5
            ProjectileRight?.position.x = (ProjectileRight?.position.x)! - 9
        }
    }
    
    func SpawnEnemy(){
        isSpawned = false
        if (SpawnedBatLeft == false || SpawnedBatUp == false || SpawnedBatRight == false || SpawnedGoblinLeft == false || SpawnedGoblinRight == false)
        {
            while (isSpawned == false)
            {
                RandomSpawn = Int.random(in: 0..<5)
                if (RandomSpawn == 0 && SpawnedBatLeft == false)
                {
                    self.BatLeft = self.childNode(withName: "BatLeft") as? SKSpriteNode
                    BatLeft?.isHidden = false
                    BatLeft?.position.x = -717
                    BatLeft?.position.y = 425
                    SpawnedBatLeft = true
                    isSpawned = true
                }
                else
                {
                    if (RandomSpawn == 1 && SpawnedBatUp == false)
                    {
                        self.BatUp = self.childNode(withName: "BatUp") as? SKSpriteNode
                        BatUp?.isHidden = false
                        BatUp?.position.x = 0
                        BatUp?.position.y = 425
                        BatUpLife = 2
                        SpawnedBatUp = true
                        isSpawned = true
                        
                    }
                    else
                    {
                        if (RandomSpawn == 2 && SpawnedBatRight == false)
                        {
                            
                            self.BatRight = self.childNode(withName: "BatRight") as? SKSpriteNode
                            BatRight?.isHidden = false
                            BatRight?.position.x = 717
                            BatRight?.position.y = 425
                            SpawnedBatRight = true
                            isSpawned = true
                            
                        }
                        else
                        {
                            if (RandomSpawn == 3 && SpawnedGoblinLeft == false)
                            {
                                GoblinLeft = SKSpriteNode(texture: SKTexture(imageNamed: "GoblinLeftAttack0"), size: CGSize(width: 81, height: 114))
                                GoblinLeft?.isHidden = false
                                GoblinLeft?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: GoblinLeft!.size.width, height: GoblinLeft!.size.height))
                                GoblinLeft?.name = "GoblinLeft"
                                GoblinLeft?.physicsBody?.affectedByGravity = false
                                GoblinLeft?.physicsBody?.isDynamic = true
                                GoblinLeft?.physicsBody!.contactTestBitMask = (GoblinLeft?.physicsBody!.collisionBitMask)!
                                GoblinLeft?.position.x = -717
                                GoblinLeft?.position.y = -190
                                SpawnedGoblinLeft = true
                                isSpawned = true
                                addChild(GoblinLeft!)
                                EndlessGoblinAttackLeft()
                            }
                            else
                            {
                                if (RandomSpawn == 4 && SpawnedGoblinRight == false)
                                {
                                    GoblinRight = SKSpriteNode(texture: SKTexture(imageNamed: "GoblinRightAttack0"), size: CGSize(width: 81, height: 114))
                                    GoblinRight?.isHidden = false
                                    GoblinRight?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: GoblinRight!.size.width, height: GoblinRight!.size.height))
                                    GoblinRight?.name = "GoblinRight"
                                    //                        self.GoblinLeft = self.childNode(withName: "GoblinLeft") as? SKSpriteNode
                                    GoblinRight?.physicsBody?.affectedByGravity = false
                                    GoblinRight?.physicsBody?.isDynamic = true
                                    GoblinRight?.physicsBody!.contactTestBitMask = (GoblinRight?.physicsBody!.collisionBitMask)!
                                    GoblinRight?.position.x = 717
                                    GoblinRight?.position.y = -190
                                    SpawnedGoblinRight = true
                                    isSpawned = true
                                    addChild(GoblinRight!)
                                    EndlessGoblinAttackRight()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "CurshieldKnight", ofType: "mp3")!)
        AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer.prepareToPlay()
        AudioPlayer.numberOfLoops = -1
        AudioPlayer.play()
        
        self.SkyCloud1 = self.childNode(withName: "SkyCloud") as? SKSpriteNode
        self.SkyCloud2 = self.childNode(withName: "SkyCloud2") as? SKSpriteNode
        
        SkyCloudParallax()
        
        self.Grass1 = self.childNode(withName: "Grass") as? SKSpriteNode
        self.Grass2 = self.childNode(withName: "Grass2") as? SKSpriteNode
        
        GrassParallax()
        
        self.Home1 = self.childNode(withName: "Home") as? SKSpriteNode
        self.Home2 = self.childNode(withName: "Home2") as? SKSpriteNode
        
        HomeParallax()
        
        self.Mount1 = self.childNode(withName: "Mount") as? SKSpriteNode
        self.Mount2 = self.childNode(withName: "Mount2") as? SKSpriteNode
        
        MountParallax()
        
        self.Mountains1 = self.childNode(withName: "Mountains") as? SKSpriteNode
        self.Mountains2 = self.childNode(withName: "Mountains2") as? SKSpriteNode
        
        MountainsParallax()
        
        self.Tree1 = self.childNode(withName: "Tree") as? SKSpriteNode
        self.Tree2 = self.childNode(withName: "Tree2") as? SKSpriteNode
        
        TreeParallax()
        
        self.HUD = self.childNode(withName: "HUD") as? SKSpriteNode
        self.HUD?.zPosition = 1
        self.HUD?.size = CGSize(width: self.frame.width, height: self.frame.height/6)
        self.HUD?.position = CGPoint(x: 0, y: self.frame.height*0.33)
        
        self.Hero = self.childNode(withName: "Hero") as? SKSpriteNode
        Hero?.physicsBody!.contactTestBitMask = (Hero?.physicsBody!.collisionBitMask)!
        
        EndlessWalk()

        self.Shield = self.childNode(withName: "Shield") as? SKSpriteNode
        Shield?.physicsBody!.contactTestBitMask = (Shield?.physicsBody!.collisionBitMask)!
        
        let Joint = SKPhysicsJointPin.joint(withBodyA: Hero!.physicsBody!, bodyB: Shield!.physicsBody!, anchor: Hero!.position)
        
        self.physicsWorld.add(Joint)

        //        BatUpEndlessFly()
        self.BackgroundGameOver = self.childNode(withName: "BackgroundGameOver") as? SKSpriteNode
        self.BackgroundGameOver?.isHidden = true
        
        self.RetryButton = self.childNode(withName: "RetryButton") as? SKSpriteNode
        self.GameOverLabel = self.childNode(withName: "GameOver") as? SKSpriteNode
        self.HighScoreGameOver = self.childNode(withName: "HighscoreGameOver") as? SKSpriteNode
        self.PointsGameOver = self.childNode(withName: "PointsGameOver") as? SKLabelNode

        self.Life1 = self.childNode(withName: "Life1") as? SKSpriteNode
        self.Life2 = self.childNode(withName: "Life2") as? SKSpriteNode
        self.Life3 = self.childNode(withName: "Life3") as? SKSpriteNode
        
        self.Points = self.childNode(withName: "Points") as? SKLabelNode
//      Gestione Highscore
        let WaitScore = SKAction.wait(forDuration: 2.0)
        let UpdateScore = SKAction.run(
        {
            self.NewScore()
        }
        )
        let SeqScore = SKAction.sequence([WaitScore,UpdateScore])
        let RepeatScore = SKAction.repeatForever(SeqScore)
        run(RepeatScore)
        
        
//      Gestione Spawn Nemici
        let WaitSpawn = SKAction.wait(forDuration: 5.0)
        let UpdateSpawn = SKAction.run(
        {
            self.SpawnEnemy()
            self.DifficultyController()
        }
        )
        let SeqSpawn = SKAction.sequence([WaitSpawn,UpdateSpawn])
        let RepeatSpawn = SKAction.repeatForever(SeqSpawn)
        SpawnAction.run(RepeatSpawn)
        addChild(SpawnAction)
        print(SpawnAction.speed)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

//        let nodes = self.nodes(at: pos)
//        let transition = SKTransition.fade(withDuration: 1)
//        if nodes.contains(RetryButton!) {
////          AudioPlayer.stop()
//            let scene = SKScene(fileNamed: "GameScene")
//            scene?.scaleMode = .aspectFill
//            self.view?.presentScene(scene!,transition: transition)

//        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = touches.first!.location(in: scene!)
        let node = scene?.atPoint(location)
        if (IsGameOver == false)
        {
            if (location.x > 0){
                print("Right Touch")
                if (PositionCounter != 0){
                    PositionCounter = PositionCounter - 1
                }
                MoveRight(ShieldPositionCounter: PositionCounter)
            }else
            {
                print("Left Touch")
                if (PositionCounter != 4){
                PositionCounter = PositionCounter + 1
                }
                MoveLeft(ShieldPositionCounter: PositionCounter)
            }
        }
        let transition = SKTransition.fade(withDuration: 1)
        if (node!.name == RetryButton?.name!) {
            AudioPlayer.stop()
            let scene = SKScene(fileNamed: "GameScene")
            scene?.scaleMode = .aspectFill
            self.view?.presentScene(scene!,transition: transition)
        }
        //        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

//        let curTouch = touches.first
//        let curPoint = curTouch!.location(in: self)
//
//        let angle = atan2((curPoint.x - (Shield?.position.x)!) , -(curPoint.y -
//                          (Shield?.position.y)!))
//         Shield?.zRotation = angle - CGFloat(Double.pi/2)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
                
        if (IsGameOver == false)
        {
            if (SpawnedBatUp == true)
            {
                if (BatUp?.position.y != 160)
                {
                    BatUp?.position.y = (BatUp?.position.y)! - 5
                }
                else
                {
                    BatShootUp()
                }
            }
            if (SpawnedBatLeft == true)
            {
                if (BatLeft?.position.y != 125)
                {
                    BatLeft?.position.y = (BatLeft?.position.y)! - 5
                    BatLeft?.position.x = (BatLeft?.position.x)! + 3
                }
                else
                {
                    BatShootLeft()
                }
                
            }
            if (SpawnedBatRight == true)
            {
                if (BatRight?.position.y != 125)
                {
                    BatRight?.position.y = (BatRight?.position.y)! - 5
                    BatRight?.position.x = (BatRight?.position.x)! - 3
                }
                else
                {
                    BatShootRight()
                }
            }
            if (SpawnedGoblinLeft == true)
            {
                if (GoblinLeft?.position.x != -217)
                {
                    GoblinLeft?.position.x = (GoblinLeft?.position.x)! + 5
                }
            }
            if (SpawnedGoblinRight == true)
            {
                if (GoblinRight?.position.x != 217)
                {
                    GoblinRight?.position.x = (GoblinRight?.position.x)! - 5
                }

            }
            
            if (Life == 2)
            {
                Life3?.texture = SKTexture(imageNamed: "LifeLose")
            }
            else
            {
                if (Life == 1)
                {
                    Life2?.texture = SKTexture(imageNamed: "LifeLose")
                }
                else
                {
                    if (Life <= 0)
                    {
                        Life1?.texture = SKTexture(imageNamed: "LifeLose")
                        GameOver()
                    
                    }
                }
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {

        if contact.bodyA.node?.name == "Hero" {
            if (contact.bodyB.node?.name == "GoblinLeft")
            {

                SpawnedGoblinLeft = false

            }
            else
            {
                if (contact.bodyB.node?.name == "GoblinRight")
                {

                    SpawnedGoblinRight = false

                }
                else
                {
                    if (contact.bodyB.node?.name == "ProjectileLeft")
                    {
                        ShootLeft = false
                    }
                    else
                    {
                        if (contact.bodyB.node?.name == "ProjectileUp")
                        {
                            ShootUp = false
                        }
                        else
                        {
                            ShootRight = false
                        }
                        
                    }
                    
                }
                
            }
            
            contact.bodyB.node?.removeFromParent()
            if (Invulnerability == false)
            {
            Life = Life - 1
            Invulnerability3sec()
            }
            
        } else if contact.bodyB.node?.name == "Hero" {
            if (contact.bodyA.node?.name == "GoblinLeft")
            {

                SpawnedGoblinLeft = false

            }
            else
            {
                if (contact.bodyA.node?.name == "GoblinRight")
                {

                    SpawnedGoblinRight = false

                }
                else
                {
                    if (contact.bodyA.node?.name == "ProjectileLeft")
                    {
                        ShootLeft = false
                    }
                    else
                    {
                        if (contact.bodyA.node?.name == "ProjectileUp")
                        {
                            ShootUp = false
                        }
                        else
                        {
                            ShootRight = false
                        }
                        
                    }
                    
                }
            }

            contact.bodyA.node?.removeFromParent()
            if (Invulnerability == false)
            {
            Life = Life - 1
            Invulnerability3sec()
            }
        
        }
        if contact.bodyA.node?.name == "Shield" {
            if (contact.bodyB.node?.name == "GoblinLeft")
            {

                SpawnedGoblinLeft = false
                Score = Score + 1000
                GoblinDeathEffect(GoblinPosition: contact.bodyB.node!.position)

            }
            else
            {
                if (contact.bodyB.node?.name == "GoblinRight")
                {

                    SpawnedGoblinRight = false
                    Score = Score + 1000
                    GoblinDeathEffect(GoblinPosition: contact.bodyB.node!.position)

                }
                else
                {
                    if (contact.bodyB.node?.name == "ProjectileLeft")
                    {
                        ShootLeft = false
                        Score = Score + 2000
                        BatLeft?.isHidden = true
                        SpawnedBatLeft = false
                        BatDeathEffect(BatPosition: BatLeft!.position)

                    }
                    else
                    {
                        if (contact.bodyB.node?.name == "ProjectileUp")
                        {
                            ShootUp = false
                            Score = Score + 2000
                            BatUpLife = BatUpLife - 1
                            if (BatUpLife == 0)
                            {
                                BatUp?.isHidden = true
                                SpawnedBatUp = false
                                BatDeathEffect(BatPosition: BatUp!.position)
                            }



                        }
                        else
                        {
                            ShootRight = false
                            Score = Score + 2000
                            BatRight?.isHidden = true
                            SpawnedBatRight = false
                            BatDeathEffect(BatPosition: BatRight!.position)

                        }
                        
                    }
                    
                }
            }
            
            contact.bodyB.node?.removeFromParent()
                        
        }
        else
        {
            if contact.bodyB.node?.name == "Shield"
            {
                if (contact.bodyA.node?.name == "GoblinLeft")
                {

                    SpawnedGoblinLeft = false
                    Score = Score + 1000
                    GoblinDeathEffect(GoblinPosition: contact.bodyA.node!.position)

                }
                else
                {
                    if (contact.bodyA.node?.name == "GoblinRight")
                    {
 
                        SpawnedGoblinRight = false
                        Score = Score + 1000
                        GoblinDeathEffect(GoblinPosition: contact.bodyA.node!.position)

                    }
                    else
                    {
                        if (contact.bodyA.node?.name == "ProjectileLeft")
                        {
                            ShootLeft = false
                            Score = Score + 2000
                            BatLeft?.isHidden = true
                            SpawnedBatLeft = false
                            BatDeathEffect(BatPosition: BatLeft!.position)
                        }
                        else
                        {
                            if (contact.bodyA.node?.name == "ProjectileUp")
                            {
                                ShootUp = false
                                Score = Score + 2000
                                BatUpLife = BatUpLife - 1
                                if (BatUpLife == 0)
                                {
                                    BatUp?.isHidden = true
                                    SpawnedBatUp = false
                                    BatDeathEffect(BatPosition: BatUp!.position)
                                }
                            }
                            else
                            {
                                ShootRight = false
                                Score = Score + 2000
                                BatRight?.isHidden = true
                                SpawnedBatRight = false
                                BatDeathEffect(BatPosition: BatRight!.position)

                            }
                            
                        }
                        
                    }
                }
                
                contact.bodyA.node?.removeFromParent()

            }
        }
    }
}
