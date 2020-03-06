

import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
  /// Register providers
  try services.register(FluentSQLiteProvider())
  
  /// Register routes to the router
  services.register(Router.self) { c -> EngineRouter in
    let router = EngineRouter.default()
    try routes(router)
    return router
  }
  
  /// Register our custom PokeAPI wrapper
  services.register(PokeAPI.self)
    
  /// Setup a simple in-memory SQLite database
  let sqlite = try SQLiteDatabase(storage: .memory)
  services.register(sqlite)
  
  /// Configure SQLite database
  services.register { c -> DatabasesConfig in
    var databases = DatabasesConfig()
    try databases.add(database: c.make(SQLiteDatabase.self), as: .sqlite)
    return databases
  }
  
  /// Configure migrations
  services.register { c -> MigrationConfig in
    var migrations = MigrationConfig()
    /// Ensure there is a table ready to store the Pokemon
    migrations.add(model: Pokemon.self, database: .sqlite)
    return migrations
  }
}
