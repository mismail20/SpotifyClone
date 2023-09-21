import UIKit

protocol ArtistsCollectionViewTableViewCellDelegate: AnyObject {
    func sendToHomeView(sender: ArtistsCollectionViewTableViewCell, modelToPass: Player)
}

class ArtistsCollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "ArtistsCollectionViewTableViewCell"
    private var artists: [Artist] = [Artist]()
    weak var delegate: ArtistsCollectionViewTableViewCellDelegate?

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 18.0 / 255.0, green: 18.0 / 255.0, blue: 18.0 / 255.0, alpha: 1.0)
        collectionView.register(ArtistCollectionViewCell.self, forCellWithReuseIdentifier: ArtistCollectionViewCell.identifier)
        return collectionView
    }()
    
    public func passToArtistsCollectionViewTableViewCell(with artists: [Artist]) {
        self.artists = artists
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ArtistsCollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return artists.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCollectionViewCell.identifier, for: indexPath) as? ArtistCollectionViewCell else { return UICollectionViewCell() }
        
        let currentCollectionCell = artists[indexPath.row]
        collectionCell.passToArtistCollectionViewCell(with: currentCollectionCell.images[0].url)
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentModel = artists[indexPath.row]
        let currentArtist = currentModel.name
        let currentImage = currentModel.images[0].url
        
        APIService.shared.getYoutubeVideo(query: "\(currentArtist) song") { result in
            switch result {
            case.success(let video):
                let sender = self
                let modelToPass = Player(title:"\(currentArtist) Trending Song" , artist: currentArtist, video: video.id.videoId, image: currentImage)
                
                self.delegate?.sendToHomeView(sender: sender, modelToPass: modelToPass)
                
            case.failure(let error): print(error)
            }
        }
        
    }
    
    
    
}
