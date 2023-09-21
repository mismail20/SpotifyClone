import UIKit

protocol TracksCollectionViewTableViewCellDelegate: AnyObject {
    func sendToHomeView(sender: TracksCollectionViewTableViewCell, modelToPass: Player)
}

class TracksCollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "TracksCollectionViewTableViewCell"
    private var tracks: [Track] = [Track]()
    weak var delegate: TracksCollectionViewTableViewCellDelegate?

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 18.0 / 255.0, green: 18.0 / 255.0, blue: 18.0 / 255.0, alpha: 1.0)
        collectionView.register(TrackCollectionViewCell.self, forCellWithReuseIdentifier: TrackCollectionViewCell.identifier)
        return collectionView
    }()
    
    public func passToTracksCollectionViewTableViewCell(with tracks: [Track]) {
        self.tracks = tracks
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

extension TracksCollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return tracks.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCollectionViewCell.identifier, for: indexPath) as? TrackCollectionViewCell else { return UICollectionViewCell() }
        
        let currentCollectionCell = tracks[indexPath.row]
        collectionCell.passToTrackCollectionViewCell(with: currentCollectionCell.album.images[0].url)
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentModel = tracks[indexPath.row]
        let currentTitle = currentModel.name
        let currentArtist = currentModel.artists[0].name
        let currentImage = currentModel.album.images[0].url
        
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
