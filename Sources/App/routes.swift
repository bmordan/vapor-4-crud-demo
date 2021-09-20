import Vapor
import Fluent
import FluentPostgresDriver

func routes(_ app: Application) throws {
    app.post("todos") {req -> EventLoopFuture<Todo> in
        let todo = try req.content.decode(Todo.self)
        return todo.create(on: req.db).map {
            todo
        }
    }
    app.get("todos") {req -> EventLoopFuture<[Todo]> in
        return Todo.query(on: req.db).all()
    }
    app.post("todos", ":id") {req -> EventLoopFuture<Todo> in
        let id = req.parameters.get("id", as: UUID.self)
        let update = try req.content.decode(Todo.self)
        return
            Todo.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {todo -> EventLoopFuture<Todo> in
                todo.task = update.task
                return todo.update(on: req.db).map {
                    todo
                }
            }
    }
    app.delete("todos", ":id") {req -> EventLoopFuture<HTTPStatus> in
        let id = req.parameters.get("id", as: UUID.self)
        return Todo.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {$0.delete(on: req.db)}
            .map { .ok }
    }
}
