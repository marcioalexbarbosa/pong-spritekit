import SpriteKit

extension SKPhysicsBody {

 func ideal() -> SKPhysicsBody {
    self.friction = 0
    self.linearDamping = 0
    self.angularDamping = 0
    self.restitution = 1
    return self
  }

  func manualMovement() -> SKPhysicsBody {
    self.isDynamic = false
    self.allowsRotation = false
    self.affectedByGravity = false
    return self
  }
    
    func movementWithMass() -> SKPhysicsBody {
      self.isDynamic = true
      self.allowsRotation = false
      self.affectedByGravity = false
      self.mass = 100
      return self
    }
}
