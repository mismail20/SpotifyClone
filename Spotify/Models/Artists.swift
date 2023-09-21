import Foundation

struct ArtistsResponse: Codable { let artists: [Artist] }

struct Artist: Codable {
    let name: String
    let images: [ArtistImage]
}

struct ArtistImage: Codable { let url: String }
