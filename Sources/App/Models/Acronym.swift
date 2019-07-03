    import Vapor
    import FluentPostgreSQL
    
    struct Acronym: Codable {
        var id: Int?
        var short: String
        var long: String
//        var createdAt: Date
//        var updatedAt: Date
//
        init(short: String, long: String) {
            self.short = short
            self.long = long
            
        }
    }
    
    extension Acronym: PostgreSQLModel {}
    
    extension Acronym: Migration {}
    
    extension Acronym: Content {}

    extension Acronym: Parameter {}
