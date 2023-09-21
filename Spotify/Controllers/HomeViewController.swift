import UIKit

class HomeViewController: UIViewController {
    
    private let tableHeaders: [String] = {
        let array = ["Popular Albums", "Trending Songs", "Popular Artists"]
        return array
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.backgroundColor = UIColor(red: 18.0 / 255.0, green: 18.0 / 255.0, blue: 18.0 / 255.0, alpha: 1.0)
        table.register(AlbumsCollectionViewTableViewCell.self, forCellReuseIdentifier: AlbumsCollectionViewTableViewCell.identifier)
        table.register(TracksCollectionViewTableViewCell.self, forCellReuseIdentifier: TracksCollectionViewTableViewCell.identifier)
        table.register(ArtistsCollectionViewTableViewCell.self, forCellReuseIdentifier: ArtistsCollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { return 3 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let albumsTableCell = tableView.dequeueReusableCell(withIdentifier: AlbumsCollectionViewTableViewCell.identifier) as? AlbumsCollectionViewTableViewCell else { return UITableViewCell() }
        
        guard let tracksTableCell = tableView.dequeueReusableCell(withIdentifier: TracksCollectionViewTableViewCell.identifier) as? TracksCollectionViewTableViewCell else { return UITableViewCell() }
        
        guard let artistsTableCell = tableView.dequeueReusableCell(withIdentifier: ArtistsCollectionViewTableViewCell.identifier) as? ArtistsCollectionViewTableViewCell else { return UITableViewCell() }
        
        albumsTableCell.delegate = self
        tracksTableCell.delegate = self
        artistsTableCell.delegate = self
        
        switch indexPath.section {
            
        case 0: //Popular Albums
            APIService.shared.getAccessToken { result in
                switch result {
                case.success(let token):
                    APIService.shared.getPopularAlbums(token: token.access_token) { result in
                        switch result {
                        case.success(let albums): albumsTableCell.passToAlbumsCollectionViewTableViewCell(with: albums.items)
                        case.failure(let error): print(error)
                        }
                    }
                case.failure(let error): print(error)
                }
            }
            return albumsTableCell
            
            
        case 1: //Trending Tracks
            APIService.shared.getAccessToken { result in
                switch result {
                case.success(let token):
                    APIService.shared.getTrendingTracks(token: token.access_token) { result in
                        switch result {
                        case.success(let tracks):
                            tracksTableCell.passToTracksCollectionViewTableViewCell(with: tracks)
                        case.failure(let error): print(error)
                        }
                    }
                case.failure(let error): print(error)
                }
            }
            return tracksTableCell
            
        case 2: //Popular Artists
            APIService.shared.getAccessToken { result in
                switch result {
                case.success(let token):
                    APIService.shared.getPopularArtists(token: token.access_token) { result in
                        switch result {
                        case.success(let artists): artistsTableCell.passToArtistsCollectionViewTableViewCell(with: artists)
                        case.failure(let error): print(error)
                        }
                    }
                case.failure(let error): print(error)
                }
            }
            return artistsTableCell
            
        default: print("Error Invalid Cell")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 410
        case 1:
            return 210
        case 2:
            return 210
        default:
            return 210
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        let originalHeaderText = header.textLabel?.text
        let formattedHeaderText = originalHeaderText!.prefix(1).capitalized + originalHeaderText!.dropFirst().lowercased()
        header.textLabel?.text = String(formattedHeaderText)
       

        header.textLabel?.font = .systemFont(ofSize: 21, weight: .bold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 50 }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return tableHeaders[section] }
}

extension HomeViewController: AlbumsCollectionViewTableViewCellDelegate {
    func sendToHomeView(sender: AlbumsCollectionViewTableViewCell, modelToPass: Player) {
        DispatchQueue.main.async { [weak self] in
            let player = PlayerViewController()
            player.passToPlayerViewController(with: modelToPass)
            self?.navigationController?.pushViewController(player, animated: true)
        }
    }
}

extension HomeViewController: TracksCollectionViewTableViewCellDelegate {
    func sendToHomeView(sender: TracksCollectionViewTableViewCell, modelToPass: Player) {
        DispatchQueue.main.async { [weak self] in
            let player = PlayerViewController()
            player.passToPlayerViewController(with: modelToPass)
            self?.navigationController?.pushViewController(player, animated: true)
        }
    }
}

extension HomeViewController: ArtistsCollectionViewTableViewCellDelegate {
    func sendToHomeView(sender: ArtistsCollectionViewTableViewCell, modelToPass: Player) {
        DispatchQueue.main.async { [weak self] in
            let player = PlayerViewController()
            player.passToPlayerViewController(with: modelToPass)
            self?.navigationController?.pushViewController(player, animated: true)
        }
    }
}

