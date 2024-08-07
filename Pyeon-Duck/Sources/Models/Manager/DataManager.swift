//
//  DataManager.swift
//  Pyeon-Duck
//
//  Created by 준우의 MacBook 16 on 12/22/23.
//

import CoreData
import Foundation

class DataManager {
    private(set) var expirationList: [Expiration] = []
    private(set) var stockCategoryList: [StockCategory] = []
    private(set) var stockItemList: [StockItem] = []

    var context = CoreDataService.context
}

// MARK: - 유통기한 CRUD

// CRUD
extension DataManager {
    // Create
    func addExpiration(_ name: String, _ image: Data, _ date: Date, isCheck: Bool) {
        let newItem = Expiration(context: context)
        newItem.id = UUID()
        newItem.name = name
        newItem.image = image
        newItem.date = date
        newItem.isCheck = isCheck

        do {
            try context.save()
            requestExpiration()
        } catch {
            print("#### Insert Error: \(error)")
        }
    }

    // Read
    func requestExpiration() {
        do {
            expirationList = try context.fetch(Expiration.fetchRequest())
        } catch {
            print("#### Fetch Error: \(error)")
        }
    }

    // Delete
    func deleteExpiration(at expiration: Expiration) {
        context.delete(expiration)
        do {
            try context.save()
            requestExpiration()
        } catch {
            print("#### Delete Error : \(error)")
        }
    }

    // Update - Content
    func updateExpiration(_ expiration: Expiration, newName: String, newDate: Date) {
        expiration.name = newName
        expiration.date = newDate

        do {
            try context.save()
            requestExpiration()
        } catch {
            print("#### Update Error : \(error)")
        }
    }

    // Update - Status
    func updateConfirm(_ expiration: Expiration, isCheck: Bool) {
        expiration.isCheck = isCheck

        do {
            try context.save()
            requestExpiration()
        } catch {
            print("#### Update Error : \(error)")
        }
    }
}

// MARK: - 보충상품: 카테고리 CRUD

extension DataManager {
    // Create
    func addStockCategory(_ name: String) {
        var newItem = StockCategory(context: context)
        newItem.name = name

        do {
            try context.save()
            requestStockCategory()
        } catch {
            print("#### Insert Error: \(error)")
        }
    }

    // Read
    func requestStockCategory() {
        do {
            stockCategoryList = try context.fetch(StockCategory.fetchRequest())
        } catch {
            print("#### Fetch Error: \(error)")
        }
    }

    // Delete
    func deleteStockCategory(at indexPath: IndexPath) {
        let itemIndexPath = stockCategoryList[indexPath.row]
        context.delete(itemIndexPath)

        do {
            try context.save()
            requestStockCategory()
        } catch {
            print("#### Delete Error: \(error)")
        }
    }

    // Update
    func updateStockCategory(_ stockCategory: StockCategory, name: String) {
        stockCategory.name = name

        do {
            try context.save()
            requestStockCategory()
        } catch {
            print("#### Update Error: \(error)")
        }
    }
}

// MARK: - 상품보충: 아이템 CRUD

extension DataManager {
    // Create
    func addStockItem(_ name: String, _ image: Data, _ count: Int, parentCategory: StockCategory) {
        let newItem = StockItem(context: context)
        newItem.name = name
        newItem.image = image
        newItem.count = Int64(count)
        newItem.parentCategory = parentCategory

        do {
            try context.save()
            requestStockItem(parentCategory: parentCategory)
        } catch {
            print("#### StockItem insert error: \(error)")
        }
    }

    // Read
    func requestStockItem(with request: NSFetchRequest<StockItem> = StockItem.fetchRequest(), predicate: NSPredicate? = nil, parentCategory: StockCategory) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", parentCategory.name ?? "N/A")

        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            stockItemList = try context.fetch(request)

        } catch {
            print("#### StockItem request error: \(error)")
        }
    }

    // Delete
    func deleteStockItem(at stockItem: StockItem, _ parentCategory: StockCategory) {
        context.delete(stockItem)

        do {
            try context.save()
            requestStockItem(parentCategory: parentCategory)
        } catch {
            print("#### Delete Stock Item Error : \(error)")
        }
    }

    // Update - Content
    func updateStockItem(stockItem: StockItem, newName: String, newImage: Data, newCount: Int, parentCategory: StockCategory) {
        stockItem.name = newName
        stockItem.image = newImage
        stockItem.count = Int64(newCount)

        do {
            try context.save()
            requestStockItem(parentCategory: parentCategory)
        } catch {
            print("#### Update Stock Item Error : \(error)")
        }
    }

    func updateStockConfirm(_ stockItem: StockItem, isCheck: Bool, parentCategory: StockCategory) {
        stockItem.isCheck = isCheck

        do {
            try context.save()
            requestStockItem(parentCategory: parentCategory)
        } catch {
            print("#### Update Error : \(error)")
        }
    }
}
