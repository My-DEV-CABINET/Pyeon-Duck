//
//  ExpirationDateVC.swift
//  Pyeon-Duck
//
//  Created by 준우의 MacBook 16 on 12/13/23.
//

/// Rx
import RxDataSources
import RxSwift

/// Apple
import UIKit

final class ExpirationCalendarVC: UIViewController {
    @IBOutlet var baseView: [UIView]!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var confirmLable: UILabel!
    @IBOutlet weak var nonConfirmLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
}

// MARK: - View Life Cycle

extension ExpirationCalendarVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup UI

extension ExpirationCalendarVC {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        confirmBaseView()
    }

    private func confirmBaseView() {
        baseView?.forEach { $0.layer.cornerRadius = 10 }
    }

    private func confirmTableView() {}
}
