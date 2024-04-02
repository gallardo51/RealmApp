//
//  Model.swift
//  RealmApp
//
//  Created by Александр Соболев on 02.04.2024.
//

import RealmSwift
import Foundation

class TaskList: Object {
    @Persisted var name = ""
    @Persisted var date = Date()
    @Persisted var tasks = List<Task>()
}

class Task: Object {
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var isComplete = false
}

