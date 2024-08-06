//
//  ExpirationDateCreateViewModel.swift
//  Pyeon-Duck
//
//  Created by 준우의 MacBook 16 on 12/29/23.
//

import Foundation

class ExpirationDateCreateViewModel {
    var dataManager = DataManager()
    var expirationItem: Expiration?
    var selectedTagNum = 1 // 1: Read 2: Update
    var sstService = SSTService.shared
}

extension ExpirationDateCreateViewModel {
    func addExpiration(_ name: String, _ date: String, _ image: Data, isCheck: Bool) {
        self.dataManager.addExpiration(name, image, date, isCheck: isCheck)
    }

    func updateExpiration(_ expiration: Expiration, newName: String, newDate: String) {
        self.dataManager.updateExpiration(expiration, newName: newName, newDate: newDate)
    }
}

extension ExpirationDateCreateViewModel {
    func dateToStrFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"

        let dateString = formatter.string(from: date)
        return dateString
    }
}
