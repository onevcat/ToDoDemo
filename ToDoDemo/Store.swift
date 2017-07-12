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
protocol CommandType {}

class Store<A: ActionType, S: StateType, C: CommandType> {
    let reducer: (_ action: A, _ state: S) -> (S, C?)
    var subscribe: ((_ state: S, _ previousState: S, _ command: C?) -> Void)?
    var state: S
    
    init(reducer: @escaping (A, S) -> (S, C?), initialState: S) {
        self.reducer = reducer
        self.state = initialState
    }
    
    func subscribe(_ handler: @escaping (S, S, C?) -> Void) {
        self.subscribe = handler
    }
    
    func unsubscribe() {
        self.subscribe = nil
    }
    
    func dispatch(_ action: A) {
        let previousState = state
        let (nextState, command) = reducer(action, state)
        state = nextState
        subscribe?(state, previousState, command)
    }
}

