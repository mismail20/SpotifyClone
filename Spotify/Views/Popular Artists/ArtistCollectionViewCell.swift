import UIKit
import SDWebImage

class ArtistCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ArtistCollectionViewCell"
    
    private let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public func passToArtistCollectionViewCell(with currentImageURL: String) {
        guard let url = URL(string: currentImageURL) else { return }
        artistImageView.sd_setImage(with: url, placeholderImage: nil)
    }
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(artistImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        artistImageView.frame = contentView.bounds
        artistImageView.layer.cornerRadius = artistImageView.frame.size.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
