//
//  GameViewController.swift
//  Chess
//
//  Created by Alessandro Rotta on 08/01/26.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, MenuSceneDelegate , GameSceneDelegate {

    weak var pauseOverlay: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {

            let scene = MenuScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            scene.menuDelegate = self
            view.presentScene(scene)
        
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.isMultipleTouchEnabled = false
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
    
    func goToMenu() {
        guard let view = self.view as? SKView else { return }
        let scene = MenuScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        scene.menuDelegate = self
        let transition = SKTransition.crossFade(withDuration: 1.0)
        view.presentScene(scene, transition: transition)
    }
    
    func didTapStartGame(matchDuration : TimeInterval) {
        guard let view = self.view as? SKView else { return }
        
        let gameScene = GameScene(size: view.bounds.size, matchDuration: matchDuration)
        gameScene.scaleMode = .aspectFill
        gameScene.gameDelegate = self
        let transition = SKTransition.crossFade(withDuration: 1.0)
        view.presentScene(gameScene, transition: transition)
        
    }
    
    func pauseGame() {
        if let skView = self.view as? SKView {
            skView.isPaused = true
        }
        showPauseMenu()
    }
    
    func showPauseMenu (){
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0
        
        var config = UIButton.Configuration.filled()
        config.title = "RESUME"
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule // Pill shape
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 40, bottom: 14, trailing: 40)
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
        outgoing.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        return outgoing
            }
        let resumeButton = UIButton(configuration: config)
                resumeButton.translatesAutoresizingMaskIntoConstraints = false
                resumeButton.addTarget(self, action: #selector(resumeTapped), for: .touchUpInside)

                // --- Assembly ---
                // IMPORTANT: Add button to contentView, not blurView directly
                blurView.contentView.addSubview(resumeButton)
                self.view.addSubview(blurView)
                self.pauseOverlay = blurView // Save reference
                
                // --- Layout (Center the button) ---
                NSLayoutConstraint.activate([
                    resumeButton.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
                    resumeButton.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor)
                ])
                
                // --- Animation ---
                UIView.animate(withDuration: 0.25) {
                    blurView.alpha = 1.0
                }
    }
    
    @objc func resumeTapped() {
            // Animate the menu away
            UIView.animate(withDuration: 0.25, animations: {
                self.pauseOverlay?.alpha = 0
            }) { _ in
                // When animation finishes:
                self.pauseOverlay?.removeFromSuperview()
                
                // Unpause the game
                if let skView = self.view as? SKView,
                           let gameScene = skView.scene as? GameScene { // Replace 'GameScene' with your actual class name
                            
                            // Call the method we created in Step 1
                            gameScene.resume()
                        }
            }
        }
}
