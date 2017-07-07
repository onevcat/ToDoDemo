//
//  Store.swift
//  ToDoDemo
//
//  Created by 王 巍 on 2017/7/6.
//  Copyright © 2017年 OneV's Den. All rights reserved.
//

import Foundation

protocol ActionType {}
protocol StateType {}

class Store<A: ActionType, S: StateType> {
    let reducer: (_ action: A, _ state: S) -> S
    var subscribe: ((_ state: S, _ previousState: S) -> Void)?
    var state: S
    
    init(reducer: @escaping (A, S) -> S, initialState: S) {
        self.reducer = reducer
        self.state = initialState
    }
    
    func subscribe(_ handler: @escaping (S, S) -> Void) {
        self.subscribe = handler
    }
    
    func unsubscribe() {
        self.subscribe = nil
    }
    
    func dispatch(_ action: A) {
        let previousState = state
        state = reducer(action, state)
        subscribe?(state, previousState)
        
    }
}

