//
//  TabBarController.swift
//  Pyeon-Duck
//
//  Created by 준우의 MacBook 16 on 12/14/23.
//

// Rx
import RxCocoa
import RxSwift

// Apple
import UIKit

final class TabBarController: UITabBarController {
    private var disposeBag = DisposeBag()

    let tabbarView = UIView()
    let tabbarItemBackgroundView = UIView()

    var buttons: [UIButton] = []
    var centerConstraint: NSLayoutConstraint?
}

// MARK: - View Life Cycle

extension TabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        generateControllers()
        setView()
        setInitialButtonState()
        buttonBind()
    }
}

// MARK: - TabBar Setup

extension TabBarController {
    private func setView() {
        view.addSubview(tabbarView)
        tabbarView.backgroundColor = .quaternarySystemFill
        tabbarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabbarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            tabbarView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60),
            tabbarView.heightAnchor.constraint(equalToConstant: 60),
            tabbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        tabbarView.layer.cornerRadius = 30

        for x in 0 ..< buttons.count {
            let button = buttons[x]
            tabbarView.addSubview(button)
            button.tag = x
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.centerYAnchor.constraint(equalTo: tabbarView.centerYAnchor),
                button.widthAnchor.constraint(equalTo: tabbarView.widthAnchor, multiplier: 1 / CGFloat(buttons.count)),
                button.heightAnchor.constraint(equalTo: tabbarView.heightAnchor)
            ])

            if x == 0 {
                button.leftAnchor.constraint(equalTo: tabbarView.leftAnchor).isActive = true
            } else {
                button.leftAnchor.constraint(equalTo: buttons[x - 1].rightAnchor).isActive = true
            }
        }

        tabbarView.addSubview(tabbarItemBackgroundView)
        tabbarItemBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        centerConstraint = tabbarItemBackgroundView.centerXAnchor.constraint(equalTo: buttons[0].centerXAnchor)
        NSLayoutConstraint.activate([
            centerConstraint!,
            tabbarItemBackgroundView.widthAnchor.constraint(equalTo: tabbarView.widthAnchor, multiplier: 1 / CGFloat(buttons.count), constant: -10),
            tabbarItemBackgroundView.heightAnchor.constraint(equalTo: tabbarView.heightAnchor, constant: -10),
            tabbarItemBackgroundView.centerYAnchor.constraint(equalTo: tabbarView.centerYAnchor)
        ])
        tabbarItemBackgroundView.layer.cornerRadius = 25
        tabbarItemBackgroundView.backgroundColor = .orange
    }

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
                        button.tintColor = sender.tag == index ? .black : .orange
                    }

                    // 선택된 버튼을 오렌지색 뷰보다 앞으로 가져오기
                    self.tabbarView.bringSubviewToFront(sender)

                    UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState) {
                        self.centerConstraint?.isActive = false
                        self.centerConstraint = self.tabbarItemBackgroundView.centerXAnchor.constraint(equalTo: self.buttons[sender.tag].centerXAnchor)
                        self.centerConstraint?.isActive = true
                        self.tabbarView.layoutIfNeeded()
                    }
                })
                .disposed(by: disposeBag)
        }
    }

    private func generateControllers() {
        let expirationReadSB = UIStoryboard(name: "ExpirationRead", bundle: nil)
        let stockCategorySB = UIStoryboard(name: "StockCategory", bundle: nil)

        guard let expirationCalendarVC = expirationReadSB.instantiateViewController(withIdentifier: "ExpirationCalendarVC") as? ExpirationCalendarVC,
              let stockCategoryVC = stockCategorySB.instantiateViewController(withIdentifier: "StockCategoryVC") as? StockCategoryVC
        else {
            return
        }

        let expiration = generateViewControllers(image: UIImage(systemName: "calendar")!, selectedImageName: "calendar", vc: expirationCalendarVC)
        let stock = generateViewControllers(image: UIImage(systemName: "shippingbox.fill")!, selectedImageName: "shippingbox.fill", vc: stockCategoryVC)
        viewControllers = [expiration, stock]
    }

    private func generateViewControllers(image: UIImage, selectedImageName: String, vc: UIViewController) -> UIViewController {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .orange
        let resizedImage = image.resize(targetSize: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
        button.setImage(resizedImage, for: .normal)
        button.setImage(UIImage(systemName: selectedImageName)?.withRenderingMode(.alwaysTemplate), for: .selected)
        buttons.append(button)
        return vc
    }

    private func buttonImageName(for index: Int, selected: Bool) -> String {
        switch index {
        case 0:
            return selected ? "calendar" : "calendar"
        case 1:
            return selected ? "shippingbox.fill" : "shippingbox"
        case 2:
            return selected ? "gearshape.fill" : "gearshape"
        case 3:
            return selected ? "bookmark.fill" : "bookmark"
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
            self.centerConstraint?.isActive = false
            self.centerConstraint = self.tabbarItemBackgroundView.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor)
            self.centerConstraint?.isActive = true
            self.tabbarView.layoutIfNeeded()
        }
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
