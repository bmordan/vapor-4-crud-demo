import Vapor
import Fluent

import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.http.server.configuration.port = Int(Environment.get("PORT") ?? "8080" ) ?? 8080
    // app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    guard var config: PostgresConfiguration = PostgresConfiguration(
            url: Environment.get("DATABASE_URL")!
        ) else {
            fatalError("Can't read DATABASE_URL postgres")
        }
    config.tlsConfiguration = .makeClientConfiguration()
    app.databases.use(.postgres(configuration: config), as: .psql)
    app.migrations.add(TodoMigration())
    try app.autoMigrate().wait()
    try routes(app)
}
