import Foundation

struct AlbumsResponse: Codable { let albums: Albums }
struct Albums: Codable { let items: [Album] }

struct Album: Codable {
    let name: String
    let artists: [AlbumArtist]
    let images: [AlbumImage]
}

struct AlbumImage: Codable { let url: String }
struct AlbumArtist: Codable { let name: String }
