//
//  GameScreenViewController.swift
//  rps-game-ios
//
//  Created by nikita on 12.06.24.
//

import UIKit

final class GameScreenViewController: UIViewController, GameScreenViewDelegate {
    
    private let gameScreenView = GameScreenView()
    
    private var timer = Timer()
    private var leftTime: Int!
    
    var point = 0
    
    var gameTime = 30
    
    override func loadView() {
        view = gameScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameScreenView.delegate = self
        setupNavigationBar()
        
        initializeGameState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startGame()
    }
    
    private func initializeGameState() {
        leftTime = gameTime
        gameScreenView.timerLabel.text = "0:\(gameTime)"
        gameScreenView.timerProgressView.progress = Float(1)
        setPoint(0, for: .top)
        setPoint(0, for: .bottom)
    }
    
    @objc
    private func pauseGame() {
        timer.isValid ? timer.invalidate() : startGame()
    }
    
    private func enableButtons(_ state: Bool) {
        gameScreenView.rockButton.isEnabled = state
        gameScreenView.paperButton.isEnabled = state
        gameScreenView.scissorsButton.isEnabled = state
        navigationController?.navigationItem.rightBarButtonItem?.isEnabled = state
    }
    
    func didTapRockButton() {
        setBottomHand(to: .bottomRock)
    }
    
    func didTapPaperButton() {
        setBottomHand(to: .bottomPaper)
    }
    
    func didTapScissorsButton() {
        setBottomHand(to: .bottomScissors)
    }
    
    func setTopHand(to gesture: Gesture) {
        gameScreenView.topHandImageView.image = gesture.image
    }
    
    func setBottomHand(to gesture: Gesture) {
        enableButtons(false)
        setCentralLabel("")
        timer.invalidate()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [unowned self] timer in
            gameScreenView.bottomHandImageView.image = gesture.image
        }
    }
    
    func setPoint(_ point: Int, for player: PlayerSide) {
        switch player {
        case .top:
            gameScreenView.topScoreProgressView.progress = Float(point) * 0.40
        case .bottom:
            gameScreenView.bottomScoreProgressView.progress = Float(point) * 0.40
        }
    }
    
    func setCentralLabel(_ text: String) {
        gameScreenView.centralLabel.text = text
    }
    
    func startGame() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] time in
            leftTime -= 1
            gameScreenView.timerLabel.text = "0:\(leftTime ?? 0)"
            gameScreenView.timerProgressView.progress = Float(leftTime ?? 0) / Float(gameTime)
            if leftTime == 0 {
                setCentralLabel("ROUND OVER") //game mechanics
                timer.invalidate()
            }
         }
    }
}

// MARK: - Setup UI
private extension GameScreenViewController {
    func setupNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.CustomColors.customBlack]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .pause,
            target: self,
            action: #selector(pauseGame)
        )
                
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = .CustomColors.customBlack
        
        title = "Игра"
    }
}

// MARK: - enum Gesture
extension GameScreenViewController {
    enum Gesture {
        case topRock
        case topPaper
        case topScissors
        case bottomRock
        case bottomPaper
        case bottomScissors
        
        var image: UIImage {
            switch self {
            case .topRock:
                #imageLiteral(resourceName: "rockFemaleHand")
            case .topPaper:
                #imageLiteral(resourceName: "paperFemaleHand")
            case .topScissors:
                #imageLiteral(resourceName: "scissorsFemaleHand")
            case .bottomRock:
                #imageLiteral(resourceName: "rockMaleHand")
            case .bottomPaper:
                #imageLiteral(resourceName: "paperMaleHand")
            case .bottomScissors:
                #imageLiteral(resourceName: "scissorsMaleHand")
            }
        }
    }
    
    enum PlayerSide {
        case top
        case bottom
    }
}



#if DEBUG
import SwiftUI

struct GameScreenViewControllerProvider: PreviewProvider {
    static var previews: some View {
        Group {
            UINavigationController(rootViewController: GameScreenViewController()).previw()
        }
    }
}
#endif
