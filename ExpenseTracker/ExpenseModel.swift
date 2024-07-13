//
//  ExpenseModel.swift
//  ExpenseTracker
//
//  Created by Gulam Ali on 09/07/24.
//


import SwiftData
import SwiftUI

@Model
class ExpenseModel {
    //@Attribute(.unique) let name : String
    var name : String
    var expenseDate : Date
    var amount : Double
    
    init(name: String, expenseDate: Date, amount: Double) {
        self.name = name
        self.expenseDate = expenseDate
        self.amount = amount
    }
}

struct MockData {
   static let sampleExpense = ExpenseModel(name: "MacBook Pro", expenseDate: .distantPast, amount: 2500)
  static  let sampleExpenseArr = [sampleExpense,sampleExpense,sampleExpense]
}
