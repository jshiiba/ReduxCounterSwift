//
//  Redux.swift
//  ReduxCounter
//
//  Created by Justin Shiiba on 4/15/17.
//  Copyright © 2017 Shiiba. All rights reserved.
//

import Foundation

enum Action {
    case addCounter
    case removeCounter(Int)
    case increaseCount(Int)
    case decreaseCount(Int)
}

// AppState
struct AppState {
    let counters: [Counter]
    let nextCounterId: Int
    let totalCount: Int
}

protocol Subscriber {
    func update(_ state: AppState)
}

protocol Reducer {
    func handle(_ action: Action, with state: AppState) -> AppState
}

struct AppReducer: Reducer {
    func handle(_ action: Action, with state: AppState) -> AppState {
        return countersReducer(action: action, state: state)
    }
}


final class Store {

    private var reducer: Reducer
    private var state: AppState
    private var subscribers: [Subscriber] = []

    init(state: AppState, reducer: Reducer) {
        self.state = state
        self.reducer = reducer
    }

    func getState() -> AppState {
        return state
    }

    func dispatch(action: Action) {
        state = reducer.handle(action, with: state)
        print(state)
        subscribers.forEach { $0.update(state) }
    }

    // listeners
    func subscribe(subscriber: Subscriber)  {
        subscribers.append(subscriber)
    }
}
