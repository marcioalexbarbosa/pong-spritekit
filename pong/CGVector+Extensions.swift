import Foundation

extension CGVector {
  init(angleRadians: CGFloat, length: CGFloat) {
    let dx = cos(angleRadians) * length
    let dy = sin(angleRadians) * length
    self.init(dx: dx, dy: dy)
  }

  init(angleDegrees: CGFloat, length: CGFloat) {
    self.init(angleRadians: angleDegrees / 180.0 * .pi, length: length)
  }

  func angleRadians() -> CGFloat {
    return atan2(dy, dx)
  }

  func angleDegrees() -> CGFloat {
    return angleRadians() * 180.0 / .pi
  }

  func length() -> CGFloat {
    return sqrt(pow(dx, 2) + pow(dy, 2))
  }
}
