//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Gulam Ali on 09/07/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment (\.modelContext) var context
    @State private var isShowingItemSheet = false
    @Query(sort: \ExpenseModel.expenseDate, order: .reverse) var expenses : [ExpenseModel]
    @State private var expenseToEdit : ExpenseModel?
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(expenses) { expense in
                    ExpenseCellView(expense: expense)
                        .onTapGesture {
                            expenseToEdit = expense
                        }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet{
                        context.delete(expenses[index])
                    }
                })
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet, content: {
                AddExpenseSheetView()
            })
            .sheet(item: $expenseToEdit, content: { expense in
                EditExpenseSheetView(expense: expense)
            })
            .toolbar(content: {
                if !expenses.isEmpty{
                    Button("", systemImage: "plus") {
                        print("add tapped")
                        isShowingItemSheet = true
                    }
                }
            })
            .overlay {
                if expenses.isEmpty{
                    ContentUnavailableView(label: {
                        Label("No Expenses", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start adding expenses to see your list")
                    },actions: {
                        Button("Add Expense") {
                            print("add expense tapped")
                            isShowingItemSheet = true
                        }
                    })
                    .offset(y: -20)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        AddExpenseSheetView()
    }
}

struct ExpenseCellView: View {
    let expense : ExpenseModel
    var body: some View{
        HStack{
            Text(expense.expenseDate,format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(expense.name)
            Spacer()
            Text(expense.amount,format: .currency(code: "INR"))
        }
    }
}

struct AddExpenseSheetView: View {
    
    @Environment (\.modelContext) var context
    @Environment (\.dismiss) private var dismiss
    @State private var name = ""
    @State private var purchaseDate = Date()
    @State private var value = 0.0
    var body: some View{
        NavigationStack{
            Form{
                TextField("Item Name", text: $name)
                DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
                TextField("Amount", value: $value, format: .currency(code: "INR"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        print("Done tapped")
                        let expense = ExpenseModel(name: name, expenseDate: purchaseDate, amount: value)
                        context.insert(expense)
                        dismiss()
                    }, label: {
                        Text("Done")
                    })
                }
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(action: {
                        print("Cancel tapped")
                        dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }

            })
            
        }
    }
}

struct EditExpenseSheetView: View {
    
    @Environment (\.modelContext) var context
    @Environment (\.dismiss) private var dismiss
    @Bindable var expense : ExpenseModel
    
    var body: some View{
        NavigationStack{
            Form{
                TextField("Item Name", text: $expense.name)
                DatePicker("Purchase Date", selection: $expense.expenseDate, displayedComponents: .date)
                TextField("Amount", value: $expense.amount, format: .currency(code: "INR"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        print("update tapped")
                        dismiss()
                    }, label: {
                        Text("Update")
                    })
                }

            })
            
        }
    }
}
