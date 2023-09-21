//
//  DownloadsTableViewCell.swift
//  Netflix
//
//  Created by Mohamed Ismail on 13/09/2023.
//

import UIKit
import SDWebImage

protocol LibraryViewTableViewCellDelegate: AnyObject {
    func sendToLibraryView(sender: LibraryTableViewCell, modelToPass: Player)
}

class LibraryTableViewCell: UITableViewCell {
    
    static let identifier = "LibraryTableViewCell"
    
    private var currentTitle: String = ""
    private var currentArtist: String = ""
    private var currentImage: String = ""
    
    weak var delegate: LibraryViewTableViewCellDelegate?
    
    private let libraryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(libraryImageView)
        configureConstraints()
        setupTapGesture()
    }
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        libraryImageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureConstraints() {
        let libraryImageViewConstraints = [
             libraryImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
             libraryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
         ]

        NSLayoutConstraint.activate(libraryImageViewConstraints)
    }
    
    public func passToLibraryViewCell(currentTitle: String, currentArtist: String, currentImage: String) {
        self.currentTitle = currentTitle
        self.currentArtist = currentArtist
        self.currentImage = currentImage
        guard let url = URL(string: "\(currentImage)") else { return }
        libraryImageView.sd_setImage(with: url, placeholderImage: nil)
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        libraryImageView.isUserInteractionEnabled = true
        libraryImageView.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        APIService.shared.getYoutubeVideo(query: "\(currentTitle) by \(currentArtist)") { result in
            switch result {
            case.success(let video):
                let sender = self
                let modelToPass = Player(title: self.currentTitle, artist: self.currentArtist, video: video.id.videoId, image: self.currentImage)
                
                self.delegate?.sendToLibraryView(sender: sender, modelToPass: modelToPass)
                
            case.failure(let error): print(error)
            }
        }

    }
    

}

