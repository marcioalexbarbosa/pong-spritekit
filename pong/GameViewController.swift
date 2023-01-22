import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? SKView {
            let scene = PongScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
            
            view.presentScene(scene)
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
