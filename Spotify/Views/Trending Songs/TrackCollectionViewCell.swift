import UIKit
import SDWebImage

class TrackCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TrackCollectionViewCell"
    
    private let trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public func passToTrackCollectionViewCell(with currentImageURL: String) {
        guard let url = URL(string: currentImageURL) else { return }
        trackImageView.sd_setImage(with: url, placeholderImage: nil)
    }
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(trackImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackImageView.frame = contentView.bounds
        trackImageView.layer.cornerRadius = 10.0
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
