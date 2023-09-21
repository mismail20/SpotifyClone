import Foundation

struct TracksResponse: Codable { let tracks: [Track]  }

struct Track: Codable {
    let album: TrackAlbum
    let artists: [TrackArtist]
    let name: String
}

struct TrackAlbum: Codable {
    let name: String
    let images: [TrackImage]
}

struct TrackArtist: Codable {
    let name: String
}

struct TrackImage: Codable {
    let url: String
}
