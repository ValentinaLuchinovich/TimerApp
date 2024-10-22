//
//  MainViewController.swift
//  JustMobi_test
//
//  Created by Валентина Лучинович on 18.10.2024.
//

import SnapKit
import UIKit

class MainViewController: UIViewController {
    
    // MARK: Constants
        
    private enum Constants {
        static let fontSize = 22.0
        static let circleViewSize = 168.0
        static let horizntalPadding = 16.0
        static let lottieBottomPadding = 6
        static let timerBottomPadding = 29.0
        static let backgroundColor = UIColor.white
        static let circleColor = UIColor.gray
        static let timerUserDefaultsKey = "FinishTimerSeconds"
        static let imageName = "present"
        static let observerName = "Foreground"
        static let timerInterval = 1.0
        static let animationInterval = 2.0
    }
    
    // MARK: Private properties
    
    private var timeSeconds = 0
    private let oldTimer: Int? = UserDefaults.standard.value(forKey: Constants.timerUserDefaultsKey) as? Int
    private var scheduledTimer = Timer()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.backgroundColor
        return view
    }()
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.circleColor
        view.layer.cornerRadius = Constants.circleViewSize/2
        return view
    }()
    
    private lazy var image: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: Constants.imageName))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAimation()
    }
}

// MARK: Action

@objc
private extension MainViewController {
    func setupTimer() {
        let timeDifference = (oldTimer ?? 0) - Int(Date().timeIntervalSince1970)
        if oldTimer == nil || timeDifference <= 0 {
            startTimer(hours: 0, minutes: 25, seconds: 0)
        } else {
            startTimer(hours: 0, minutes: 0, seconds: oldTimer! - Int(Date().timeIntervalSince1970))
        }
    }
}


// MARK: Private methods

private extension MainViewController {
    
    func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupTimer), name: Notification.Name(Constants.observerName), object: nil)
        
        configureLayout()
        setupTimer()
    }
    
    func configureLayout() {
        view.addSubview(contentView)
        contentView.addSubview(circleView)
        circleView.addSubview(image)
        circleView.addSubview(timerLabel)
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        circleView.snp.makeConstraints { make in
            make.size.equalTo(Constants.circleViewSize)
            make.center.equalTo(view.snp.center)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(timerLabel.snp.top).inset(Constants.lottieBottomPadding)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.timerBottomPadding)
        }
    }
    
    func startTimer(hours: Int, minutes: Int, seconds: Int) {
        scheduledTimer.invalidate()
        timeSeconds = hours * 3600 + minutes * 60 + seconds
        saveCurrentTime()
        setupTimerLabelText()
        
        scheduledTimer = Timer.scheduledTimer(withTimeInterval: Constants.timerInterval, repeats: true, block: { timer in
            if self.timeSeconds == 0 {
                timer.invalidate()
                UserDefaults.standard.removeObject(forKey: Constants.timerUserDefaultsKey)
            }
            self.setupTimerLabelText()
            self.timeSeconds -= 1
        })
        RunLoop.main.add(scheduledTimer, forMode: .common)
    }
    
    func setupTimerLabelText() {
        self.timerLabel.text = self.counting(time: TimeInterval(self.timeSeconds))
        self.timerLabel.attributedText = self.timerLabel.strokeText()
    }
    
    func counting(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func saveCurrentTime() {
        let secondSince1970 = Date().timeIntervalSince1970
        let finishTimerSeconds = Int(secondSince1970) + timeSeconds
        UserDefaults.standard.set(finishTimerSeconds, forKey: Constants.timerUserDefaultsKey)
    }
    
    func startAimation() {
        let timer = Timer.scheduledTimer(withTimeInterval: Constants.animationInterval, repeats: true, block: { _ in
            Animations.shake(on: self.image)
        })
    }
}
