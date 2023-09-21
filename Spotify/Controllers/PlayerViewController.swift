import UIKit
import WebKit

class PlayerViewController: UIViewController {
    
    private var currentModel: Library = Library(title: "", artist: "", image: "")
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let albumName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let albumArtist: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addToLibrary: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Add To Library", for: .normal)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.layer.masksToBounds = true
        return button
    }()
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addToLibrary.isUserInteractionEnabled = true
        addToLibrary.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        let buttonTitle = addToLibrary.title(for: .normal)
        if buttonTitle == " Add To Library" {
            CoreData.shared.saveTitle(model: currentModel) { result in
                switch result {
                case.success(let result):
                    print("Downloaded")
                    print(result)
                case.failure(let error):
                    print(error)
                }
            }
            self.addToLibrary.setTitle(" Remove", for: .normal)
            self.addToLibrary.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        if buttonTitle == " Remove" {
            CoreData.shared.removeTitle(model: currentModel) { result in
                switch result {
                case.success(let result):
                    print("Removed")
                    print(result)
                case.failure(let error):
                    print(error)
                }
            }
            self.addToLibrary.setTitle(" Add To Library", for: .normal)
            self.addToLibrary.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
    }
    
    private func checkDownloaded() {
        CoreData.shared.fetchLibrary { result in
            switch result {
            case.success(let library):
                for title in library {
                    if title.title == self.currentModel.title {
                        self.addToLibrary.setTitle("Remove", for: .normal)
                    }
                }
            case.failure(let error):
                print(error)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(albumName)
        view.addSubview(albumArtist)
        view.addSubview(addToLibrary)
        configureConstraints()
        setupTapGesture()
        checkDownloaded()
    }
    
    private func configureConstraints() {
        let webViewConstraints = [
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            webView.heightAnchor.constraint(equalToConstant: 250)
        ]

        let albumNameConstraints = [
            albumName.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Center horizontally
            albumName.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20) // Place below webView
        ]

        let albumArtistConstraints = [
            albumArtist.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Center horizontally
            albumArtist.topAnchor.constraint(equalTo: albumName.bottomAnchor, constant: 20) // Place below albumName
        ]

        let addToLibraryConstraints = [
            addToLibrary.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Center horizontally
            addToLibrary.topAnchor.constraint(equalTo: albumArtist.bottomAnchor, constant: 20) // Place below albumArtist
        ]

        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(albumNameConstraints)
        NSLayoutConstraint.activate(albumArtistConstraints)
        NSLayoutConstraint.activate(addToLibraryConstraints)
    }

    
    public func passToPlayerViewController(with model: Player) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.video)") else { return }
        webView.load(URLRequest(url: url))
        albumName.text = "Song Name: \(model.title)"
        albumArtist.text = "by: \(model.artist)"
        currentModel = Library(title: model.title, artist: model.artist, image: model.image)
    }

}
