import SpriteKit
import GameplayKit

class PongScene: SKScene, SKPhysicsContactDelegate {
    
    var lastUpdateTime: TimeInterval = 0
    var lastMoved: TimeInterval = 0
        
    var ball: SKShapeNode?
    var fire: SKEmitterNode?
    var topPaddle: SKShapeNode?
    var leftWall: SKShapeNode?
    var rightWall: SKShapeNode?
    var bottomPaddle: SKShapeNode?
    var topBallDetector: SKShapeNode?
    var bottomBallDetector: SKShapeNode?
    var topScore: SKLabelNode?
    var bottomScore: SKLabelNode?
    
    var up: Bool = true

    var topPoints: Int = 0 {
        didSet {
            topScore!.text = "\(topPoints)"
        }
    }
    
    var bottomPoints: Int = 0 {
        didSet {
            bottomScore!.text = "\(bottomPoints)"
        }
    }
    
    let ballRadius: CGFloat = 10
    let paddleSize = CGSize(width: 100, height: 10)
    let paddleEdgeOffset: CGFloat = 60
    let wallWidth: CGFloat = 10
    
    override func didMove(to view: SKView) {
        startGame()
    }
    
    func startGame() {
        self.removeAllChildren()
        self.backgroundColor = SKColor.darkGray
        setUpPhysicsWorld()
        createBall()
        createWalls()
        createPassedBallDetectors()
        createPaddles()
        createScore()
        
        resetBall()
    }
    
    func setUpPhysicsWorld() {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
    }
    
    func createVerticalWall(x: CGFloat) -> SKShapeNode {
        let wallSize = CGSize(width: wallWidth, height: size.height)
        let wall = SKShapeNode(rectOf: wallSize)
        wall.physicsBody =
        SKPhysicsBody(rectangleOf: wallSize)
            .ideal()
            .manualMovement()
        
        wall.position = CGPoint(x: x, y: size.height/2)
        wall.strokeColor = .white
        wall.fillColor = .white
        
        wall.physicsBody?.contactTestBitMask = 4
        
        addChild(wall)
        
        return wall
    }
    
    func createBall() {
        let ball = SKShapeNode(circleOfRadius: ballRadius)
        
        let pointX = Double.random(in: 10.0 ..< size.width - 20.0)
        let pointY = Double.random(in: 10.0 ..< size.height / 2)

        ball.position = CGPoint(x: pointX, y: pointY)
        ball.physicsBody =
        SKPhysicsBody(circleOfRadius: ballRadius)
            .ideal()
        
        ball.strokeColor = .systemBlue
        ball.fillColor = .systemBlue
                        
        addChild(ball)
        self.ball = ball
        
        if let fireParticles = SKEmitterNode(fileNamed: "Fireball") {
            let emitterVector = CGVectorMake(ball.frame.size.width * 1.1, 0);
            fireParticles.particlePositionRange = emitterVector
            
            self.fire = fireParticles
            self.ball?.addChild(fireParticles)
        }
    }
    
    func resetBall() {
        let velocity = Double.random(in: 200.0 ..< 700.0)
        self.up = true
        ball?.physicsBody?.velocity = CGVector(dx: velocity, dy: velocity)
    }
    
    func createWalls() {
        self.leftWall = createVerticalWall(x: wallWidth/2)
        self.rightWall = createVerticalWall(x: size.width - wallWidth/2)
    }

    func createPaddle(y: CGFloat, moving: Bool) -> SKShapeNode {
        let paddle = SKShapeNode(rectOf: paddleSize)
        paddle.physicsBody =
        SKPhysicsBody(rectangleOf: paddleSize)
            .ideal()
            .movementWithMass()
        
        paddle.position = CGPoint(x: size.width/2, y: y)
        paddle.strokeColor = .cyan
        paddle.fillColor = .cyan
        
        if moving {
            paddle.physicsBody?.contactTestBitMask = 8
            paddle.physicsBody?.velocity = CGVector(dx: 600, dy: 0)
        }
                
        addChild(paddle)
        return paddle
    }
    
    func createPaddles() {
        self.topPaddle = createPaddle(y: size.height - paddleEdgeOffset, moving: true)
        self.bottomPaddle = createPaddle(y: paddleEdgeOffset, moving: false)
    }
    
    func createScore() {
        bottomScore = SKLabelNode(fontNamed: "Chalkduster")
        bottomScore!.text = "0"
        bottomScore!.color = .black
        bottomScore!.horizontalAlignmentMode = .right
        bottomScore!.position = CGPoint(x: size.width - 20, y: 20)
        addChild(bottomScore!)
        topScore = SKLabelNode(fontNamed: "Chalkduster")
        topScore!.text = "0"
        topScore!.color = .black
        topScore!.horizontalAlignmentMode = .right
        topScore!.position = CGPoint(x: size.width - 20, y: size.height - 40)
        addChild(topScore!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        defer {
            lastUpdateTime = currentTime
        }
        
        guard lastUpdateTime > 0 else {
            return
        }

        self.fire?.targetNode = self;
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
      if didContact(contact, between: self.ball, and: self.bottomBallDetector) {
          topPoints += 1
          self.ball?.removeFromParent()
          createBall()
          resetBall()
      }
        
        if didContact(contact, between: self.ball, and: self.topBallDetector) {
            bottomPoints += 1
            self.ball?.removeFromParent()
            createBall()
            resetBall()
        }
        
        if (didContact(contact, between: self.ball, and: topPaddle)) {
            self.up = false
        }

    }
  
    func createBallDetector(y: CGFloat) -> SKShapeNode {
      let detectorSize = CGSize(width: size.width, height: 1)
      let detector = SKShapeNode(rectOf: detectorSize)
      detector.physicsBody =
        SKPhysicsBody(rectangleOf: detectorSize)
        .ideal()
        .manualMovement()

      detector.position = CGPoint(x: size.width/2, y: y)
      detector.strokeColor = self.backgroundColor
      detector.fillColor = self.backgroundColor

      detector.physicsBody?.contactTestBitMask = 1

      addChild(detector)
      return detector
    }
    
    func createPassedBallDetectors() {
      self.bottomBallDetector = createBallDetector(y: 0)
      self.topBallDetector = createBallDetector(y: size.height)
    }
    
    func didContact(_ contact: SKPhysicsContact, between nodeA: SKNode?, and nodeB: SKNode?) -> Bool {
      return
        (contact.bodyA == nodeA?.physicsBody &&
          contact.bodyB == nodeB?.physicsBody) ||
        (contact.bodyA == nodeB?.physicsBody &&
          contact.bodyB == nodeA?.physicsBody)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            bottomPaddle?.physicsBody?.velocity = CGVector(dx: 460, dy: 0)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bottomPaddle?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
}
