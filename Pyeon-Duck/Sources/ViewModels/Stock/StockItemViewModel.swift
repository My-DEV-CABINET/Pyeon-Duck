//
//  StockDetailViewModel.swift
//  Pyeon-Duck
//
//  Created by 준우의 MacBook 16 on 12/30/23.
//

import Foundation

class StockItemViewModel {
    private var dataManager = DataManager()
    var selectedStockCategory: StockCategory?

    var requestStockItemCount: Int {
        return self.dataManager.stockItemList.count
    }

    var stockItemList: [StockItem] {
        return self.dataManager.stockItemList.sorted { $0.isCheck && !$1.isCheck }
    }
}

// MARK: - CRUD

extension StockItemViewModel {
    func fetchStockItem(_ parentCategory: StockCategory) {
        self.dataManager.requestStockItem(parentCategory: parentCategory)
    }

    func deleteStockItem(at stockItem: StockItem, parentCategory: StockCategory) {
        self.dataManager.deleteStockItem(at: stockItem, parentCategory)
    }

    func updateStockItem(stockItem: StockItem, newTitle: String, newImage: Data, newCount: Int, parentCategory: StockCategory) {
        self.dataManager.updateStockItem(stockItem: stockItem, newName: newTitle, newImage: newImage, newCount: newCount, parentCategory: parentCategory)
    }

    func updateCompletedStatus(_ stockItem: StockItem, isConfirm: Bool, parentCategory: StockCategory) {
        self.dataManager.updateStockConfirm(stockItem, isCheck: isConfirm, parentCategory: parentCategory)
    }
}
