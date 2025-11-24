import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor
import Gatekeeper

public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // MARK: MySQL configuration
    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 3306,
        username: Environment.get("DATABASE_USERNAME") ?? "root",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "zakfit"
    ), as: .mysql)
    
    // MARK: CORS & Gatekeeper
    //    let corsConfiguration = CORSMiddleware.Configuration(
    //        allowedOrigin: .custom("http://localhost"),
    //        allowedMethods: [.GET, .POST, .PATCH, .DELETE],
    //        allowedHeaders: [.accept, .authorization, .contentType, .origin],
    //        cacheExpiration: 800
    //    )
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .none,
        allowedMethods: [],
        allowedHeaders: []
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfiguration))
    app.gatekeeper.config = .init(maxRequests: 60, per: .minute)
    app.middleware.use(GatekeeperMiddleware())
        
    // MARK: Routes
    try routes(app)
}

struct Config {
    static let shared = Config()
    
    // Get JWT secret key from schemes if available
    let jwtSecret = Environment.get("JWT_SECRET") ?? "mysecretkey"
}
