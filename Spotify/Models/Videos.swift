import Foundation

struct Videos: Codable { let items: [Video] }

struct Video: Codable { let id: VideoID }

struct VideoID: Codable {
    let kind: String
    let videoId: String
}

