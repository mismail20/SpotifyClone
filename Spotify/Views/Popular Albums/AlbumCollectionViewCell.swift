import UIKit
import SDWebImage

class AlbumCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AlbumCollectionViewCell"
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public func passToAlbumCollectionViewCell(with currentImageURL: String) {
        guard let url = URL(string: currentImageURL) else { return }
        albumImageView.sd_setImage(with: url, placeholderImage: nil)
    }
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(albumImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumImageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
