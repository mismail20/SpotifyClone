import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: LibraryViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "music.note.list")
        
        vc1.title = "Home"
        vc2.title = "Library"
        
        setViewControllers([vc1, vc2], animated: true)
    }
    



}
