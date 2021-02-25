//
//  Task.swift
//  Todo list using filtering operators in rxswift
//
//  Created by kairzhan on 2/25/21.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
