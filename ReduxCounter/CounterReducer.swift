//
//  CounterReducer.swift
//  ReduxCounter
//
//  Created by Justin Shiiba on 4/15/17.
//  Copyright © 2017 Shiiba. All rights reserved.
//

import Foundation

func countersReducer(action: Action, state: AppState) -> AppState {
    switch action {
    case .addCounter:
        let lastCounterId = state.counters.isEmpty ? 0 : (state.counters.last?.id ?? 0) + 1
        let counter = Counter(id: lastCounterId, count: 0)
        let newCounters = state.counters + [counter]
        return AppState(counters: newCounters,
                        nextCounterId: counter.id + 1,
                        totalCount: totalCountReducer(counters: newCounters))

    case .removeCounter(let id):
        guard let counterIndex = state.counters.index(where: { $0.id == id }) else { return state }
        let newCounters = remove(at: counterIndex, from: state.counters)
        return AppState(counters: newCounters,
                        nextCounterId: newCounters.isEmpty ? 0 : state.nextCounterId,
                        totalCount: totalCountReducer(counters: newCounters))
    case .increaseCount: fallthrough
    case .decreaseCount:
        return valueChangedReducer(action, state: state)
    }
}


func totalCountReducer(counters: [Counter]) -> Int {
    return counters.map{ $0.count }.reduce(0, +)
}

// Helpers 

func valueChangedReducer(_ action: Action, state: AppState) -> AppState {
    switch action {
    case .increaseCount(let counterId):
        guard let counterIndex = state.counters.index(where: { $0.id == counterId }) else { return state }
        let newCounters = modify(state.counters, at: counterIndex, transform: increment)
        return AppState(counters: newCounters, nextCounterId: state.nextCounterId, totalCount: totalCountReducer(counters: newCounters))
    case .decreaseCount(let counterId):
        guard let counterIndex = state.counters.index(where: { $0.id == counterId }) else { return state }
        let newCounters = modify(state.counters, at: counterIndex, transform: decrement)
        return AppState(counters: newCounters, nextCounterId: state.nextCounterId, totalCount: totalCountReducer(counters: newCounters))
    default:
        return state
    }
}

func increment(counter: Counter) -> Counter {
    return changeCount(+, counter: counter)
}

func decrement(counter: Counter) -> Counter {
    return changeCount(-, counter: counter)
}

func changeCount(_ sign: (Int, Int) -> Int, counter: Counter) -> Counter {
    return Counter(id: counter.id, count: sign(counter.count, 1))
}


/// Performs transform on object T at index in array [T]
/// - parameter elements:
/// - parameter index: index to perform transform, returns array if out of bounds
/// - parameter transform: function that transforms value at index
///
/// - returns [T]: immutable array of [T]
func modify<T>(_ elements: [T], at index: Int, transform: ((T) -> (T))? = nil) -> [T] {
    guard index >= 0 && index < elements.count, let transform = transform else {
        return elements
    }

    // preforms tranform on object at index in array and returns new immutable array
    return elements[0..<index] + [transform(elements[index])] + elements[index+1..<elements.count]
}

func remove<T>(at index: Int, from elements: [T]) -> [T] {
    guard index >= 0 && index < elements.count else {
        return elements
    }

    // weird compiler error if Array() isnt used?
    return Array(elements[0..<index]) + elements[index+1..<elements.count]
}
