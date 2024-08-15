//
//  MainTabView.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 8/16/24.
//

// Rx
import RxCocoa
import RxSwift

// Autolayout
import SnapKit

// Apple
import UIKit

final class MainTabView: UITabBarController {
    private var disposeBag = DisposeBag()

    let tabbarView = UIView()
    let tabbarItemBackgroundView = UIView()

    var buttons: [UIButton] = []
    var centerConstraint: Constraint?
}

// MARK: - View Life Cycle

extension MainTabView {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
}

// MARK: - TabBar Setup

extension MainTabView {
    func setupUI() {
        tabBar.isHidden = true
        setView()
        setInitialButtonState()
        buttonBind()
    }

    private func setView() {
        view.addSubview(tabbarView)
        tabbarView.backgroundColor = .black
        tabbarView.layer.cornerRadius = 30
        tabbarView.layer.masksToBounds = true

        tabbarView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalToSuperview().offset(-60)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }

        for x in 0 ..< buttons.count {
            let button = buttons[x]
            tabbarView.addSubview(button)
            button.tag = x

            button.snp.makeConstraints { make in
                make.centerY.equalTo(tabbarView)
                make.width.equalTo(tabbarView).multipliedBy(1.0 / CGFloat(buttons.count))
                make.height.equalTo(tabbarView)

                if x == 0 {
                    make.left.equalTo(tabbarView)
                } else {
                    make.left.equalTo(buttons[x - 1].snp.right)
                }
            }
        }

        tabbarView.addSubview(tabbarItemBackgroundView)
        tabbarItemBackgroundView.layer.cornerRadius = 25
        tabbarItemBackgroundView.backgroundColor = .systemOrange

        tabbarItemBackgroundView.snp.makeConstraints { make in
            centerConstraint = make.centerX.equalTo(buttons[0].snp.centerX).constraint
            make.width.equalTo(tabbarView.snp.width).multipliedBy(1.0 / CGFloat(buttons.count)).offset(-10)
            make.height.equalTo(tabbarView.snp.height).offset(-10)
            make.centerY.equalTo(tabbarView)
        }
    }

    private func buttonImageName(for index: Int, selected: Bool) -> String {
        switch index {
        case 0:
            return selected ? TabViewImageCollection.language.symbolName : TabViewImageCollection.language.symbolName
        case 1:
            return selected ? TabViewImageCollection.morse.symbolName : TabViewImageCollection.morse.symbolName
        case 2:
            return selected ? TabViewImageCollection.history.symbolName : TabViewImageCollection.history.symbolName
        case 3:
            return selected ? TabViewImageCollection.bookmark.symbolName : TabViewImageCollection.bookmark.symbolName
        default:
            return ""
        }
    }

    private func setInitialButtonState() {
        guard let firstButton = buttons.first else { return }
        firstButton.tintColor = .black
        tabbarView.bringSubviewToFront(firstButton)

        let imageName = buttonImageName(for: 0, selected: true)
        firstButton.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)

        UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState) {
            self.centerConstraint?.deactivate()
            self.tabbarItemBackgroundView.snp.makeConstraints { make in
                self.centerConstraint = make.centerX.equalTo(firstButton.snp.centerX).constraint
            }
            self.centerConstraint?.activate()
            self.tabbarView.layoutIfNeeded()
        }
    }
}

// MARK: - Binding

extension MainTabView {
    private func buttonBind() {
        for button in buttons {
            button.rx.tap
                .asDriver()
                .drive(onNext: { [weak self, weak button] in
                    guard let self = self, let sender = button else { return }
                    self.selectedIndex = sender.tag

                    for (index, button) in self.buttons.enumerated() {
                        let imageName = self.buttonImageName(for: index, selected: sender.tag == index)
                        button.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
                        button.tintColor = sender.tag == index ? .black : .white
                    }

                    self.tabbarView.bringSubviewToFront(sender)

                    UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState) {
                        self.centerConstraint?.deactivate()
                        self.tabbarItemBackgroundView.snp.makeConstraints { make in
                            self.centerConstraint = make.centerX.equalTo(self.buttons[sender.tag].snp.centerX).constraint
                        }
                        self.centerConstraint?.activate()
                        self.tabbarView.layoutIfNeeded()
                    }
                })
                .disposed(by: disposeBag)
        }
    }
}
