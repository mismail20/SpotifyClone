import UIKit

class LibraryViewController: UIViewController {
    
    private var library: [LibraryItem] = [LibraryItem]()
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(LibraryTableViewCell.self, forCellReuseIdentifier: "LibraryTableViewCell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "Library"
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDownloads()
    }
    
    private func fetchDownloads() {
          CoreData.shared.fetchLibrary { result in
              switch result {
              case.success(let titles):
                  self.library = titles
                  self.tableView.reloadData()
              case.failure(let error):
                  print(error)
              }
          }
      }
}

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return library.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: "LibraryTableViewCell", for: indexPath) as? LibraryTableViewCell else {
            return UITableViewCell() }
        
        guard let currentTitle = library[indexPath.section].title else { return UITableViewCell() }
        guard let currentArtist = library[indexPath.section].artist else { return UITableViewCell() }
        guard let currentImage = library[indexPath.section].image else { return UITableViewCell() }
        tableCell.passToLibraryViewCell(currentTitle: currentTitle, currentArtist: currentArtist, currentImage: currentImage)
        tableCell.delegate = self
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        let originalHeaderText = header.textLabel?.text
        let formattedHeaderText = originalHeaderText!.prefix(1).capitalized + originalHeaderText!.dropFirst().lowercased()
        header.textLabel?.text = String(formattedHeaderText)
       

        header.textLabel?.font = .systemFont(ofSize: 21, weight: .bold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: header.bounds.width, height: header.bounds.height)
        header.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return library[section].title
    }
    
}

extension LibraryViewController: LibraryViewTableViewCellDelegate {
    func sendToLibraryView(sender: LibraryTableViewCell, modelToPass: Player) {
        DispatchQueue.main.async { [weak self] in
            let player = PlayerViewController()
            player.passToPlayerViewController(with: modelToPass)
            self?.navigationController?.pushViewController(player, animated: true)
        }
    }
}
