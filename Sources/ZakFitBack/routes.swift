import Fluent
import Vapor
import VaporToOpenAPI

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
    .excludeFromOpenAPI()
    
    // generate OpenAPI documentation
    app.get("swagger", "swagger.json") { req in
      req.application.routes.openAPI(
        info: InfoObject(
          title: "ZakFit API",
          description: "Internal API for the fitness and nutrition app ZakFit for iOS.",
          version: "1.0.0",
        )
      )
    }
    .excludeFromOpenAPI()

    try app.register(collection: UserController())
    try app.register(collection: MealTypeController())
    try app.register(collection: RestrictionTypeController())
}
