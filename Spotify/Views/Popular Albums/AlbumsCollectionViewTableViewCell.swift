import UIKit

protocol AlbumsCollectionViewTableViewCellDelegate: AnyObject {
    func sendToHomeView(sender: AlbumsCollectionViewTableViewCell, modelToPass: Player)
}

class AlbumsCollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "AlbumsCollectionViewTableViewCell"
    private var albums: [Album] = [Album]()
    weak var delegate: AlbumsCollectionViewTableViewCellDelegate?

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 18.0 / 255.0, green: 18.0 / 255.0, blue: 18.0 / 255.0, alpha: 1.0)
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        return collectionView
    }()
    
    public func passToAlbumsCollectionViewTableViewCell(with albums: [Album]) {
        self.albums = albums
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

extension AlbumsCollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return albums.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        
        let currentCollectionCell = albums[indexPath.row]
        collectionCell.passToAlbumCollectionViewCell(with: currentCollectionCell.images[0].url)
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentModel = albums[indexPath.row]
        let currentTitle = currentModel.name
        let currentArtist = currentModel.artists[0].name
        let currentImage = currentModel.images[0].url
        
        APIService.shared.getYoutubeVideo(query: "\(currentTitle) by \(currentArtist)") { result in
            switch result {
            case.success(let video):
                let sender = self
                let modelToPass = Player(title: currentTitle, artist: currentArtist, video: video.id.videoId, image: currentImage)
                
                self.delegate?.sendToHomeView(sender: sender, modelToPass: modelToPass)
                
            case.failure(let error): print(error)
            }
        }
        
    }
    
    
    
}
