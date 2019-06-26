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
    
    router.get("api", "acronyms", Acronym.parameter) { (req: Request) -> Future<Acronym> in
//        guard let id: Int = req.parameters.next(Int.self) else {
//            return req.future(nil)
//        }
        
//        do {
//            return try Acronym.find(0, on: req)
//        } catch {
//            return req.future(nil)
//        }
        
        return req.future(Acronym(short: "rtfm", long: "red trolls fight madly"))
        
        
//        return Acronym.query(on: req).all()
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
