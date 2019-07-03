import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.post("api", "acronyms") { req in
        return try req.content.decode(Acronym.self)
            .flatMap { acronym in
                return acronym.save(on: req)
        }
    }
    
    router.get("api", "acronyms", Int.parameter) { req -> Future<Acronym> in
        let id: Int = try req.parameters.next(Int.self)
        
        return Acronym.find(id, on: req).unwrap(or: Abort(.notFound))
    }
    
    router.get("api", "acronyms") { req -> Future<[Acronym]> in
        return Acronym.query(on: req).all()
    }
    
    router.put("api", "acronyms", Acronym.parameter) { req in
        return try flatMap(
            to: Acronym.self,
            req.parameters.next(Acronym.self),
            req.content.decode(Acronym.self)
        ) { acronym, updatedAcronym -> Future<Acronym> in
                acronym.short = updatedAcronym.short
                acronym.long = updatedAcronym.long
                
                return acronym.save(on: req)
        }
    }
    
    router.delete("api", "acronyms", Acronym.parameter) { req -> Future<HTTPStatus> in
        return try req.parameters.next(Acronym.self)
            .delete(on: req)
            .transform(to: .noContent)
    }
}
