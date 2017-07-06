//
//  ToDoStore.swift
//  ToDoDemo
//
//  Created by 王 巍 on 2017/7/6.
//  Copyright © 2017年 OneV's Den. All rights reserved.
//

import Foundation

let dummy = [
    "Buy the milk",
    "Take my dog",
    "Rent a car"
]

struct ToDoStore {
    static let shared = ToDoStore()
    func getToDoItems(completionHandler: (([String]) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completionHandler?(dummy)
        }
    }
}
