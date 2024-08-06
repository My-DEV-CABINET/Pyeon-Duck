//
//  StockCreateViewModel.swift
//  Pyeon-Duck
//
//  Created by 준우의 MacBook 16 on 12/30/23.
//

import Foundation

class StockCreateViewModel {
    private var dataManager = DataManager()
    var selectedStockCategory: StockCategory?
    var stockItem: StockItem?
    var actionTag = 1 // 1: Create 2: Update
    var sstService = SSTService.shared
}

extension StockCreateViewModel {
    func addStockItem(_ title: String, _ image: Data, _ count: Int64, _ selectedCategory: StockCategory) {
        self.dataManager.addStockItem(title, image, Int(count), parentCategory: selectedCategory)
    }

    func updateStockItem(stockItem: StockItem, newTitle: String, newImage: Data, newCount: Int, selectedCategory: StockCategory) {
        self.dataManager.updateStockItem(stockItem: stockItem, newName: newTitle, newImage: newImage, newCount: newCount, parentCategory: selectedCategory)
    }
}
