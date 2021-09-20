//
//  File.swift
//  
//
//  Created by Bernard Mordan on 17/09/2021.
//

import Foundation
import Vapor
import Fluent

final class Todo: Model {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "task")
    var task: String
    
    @Field(key: "status")
    var status: Int8
    
    init() { }
    
    init(id: UUID? = nil, task: String, status: Int8 = 0) {
        self.id = id
        self.task = task
        self.status = status
    }
}

struct TodoMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Todo.schema)
            .id()
            .field("task", .string)
            .field("status", .int8)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Todo.schema).delete()
    }
}

extension Todo: Content {}
