import Foundation

struct Token: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
}
