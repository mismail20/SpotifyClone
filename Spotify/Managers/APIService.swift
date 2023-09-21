import Foundation

struct Constants {
    static let spotifyArtistID = [""]
    static let spotifyClientID = ""
    static let spotifyClientSecret = ""
    static let youtubeApiKey = ""
    static let spotifyAuthURL = ""
    static let spotifyBaseURL = ""
    static let youtubeBaseURL = ""
}

class APIService {
    static let shared = APIService()
    
    func getAccessToken(completion: @escaping (Result<Token, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.spotifyAuthURL)/api/token") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials&client_id=\(Constants.spotifyClientID)&client_secret=\(Constants.spotifyClientSecret)".data(using: .utf8)
   
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(Token.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func getPopularAlbums(token: String, completion: @escaping (Result<Albums, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.spotifyBaseURL)/browse/new-releases") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(AlbumsResponse.self, from: data)
                completion(.success(results.albums))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getTrendingTracks(token: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        let randomArtist = Constants.spotifyArtistID[Int.random(in: 0..<Constants.spotifyArtistID.count)]
        guard let url = URL(string: "\(Constants.spotifyBaseURL)/artists/\(randomArtist)/top-tracks?market=US") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do  {
                let results = try JSONDecoder().decode(TracksResponse.self, from: data)
                completion(.success(results.tracks))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func getPopularArtists(token: String, completion: @escaping (Result<[Artist], Error>) -> Void) {
        let randomArtist = Constants.spotifyArtistID[Int.random(in: 0..<Constants.spotifyArtistID.count)]
        guard let url = URL(string: "\(Constants.spotifyBaseURL)/artists/\(randomArtist)/related-artists") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do  {
                let results = try JSONDecoder().decode(ArtistsResponse.self, from: data)
                completion(.success(results.artists))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func getYoutubeVideo(query: String, completion: @escaping (Result<Video, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youtubeBaseURL)q=\(query)&key=\(Constants.youtubeApiKey)&type=video") else { return }
        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(Videos.self, from: data)
                print(results)
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
