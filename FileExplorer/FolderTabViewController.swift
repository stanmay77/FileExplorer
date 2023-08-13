import UIKit
import Foundation

class FolderTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
            
        let VC1 = FolderViewController()
        VC1.tabBarItem = UITabBarItem(title: "Файлы", image: UIImage(systemName: "folder"), tag: 1)
        
        let VC2 = SettingsViewController()
        VC2.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 2)
        
        self.setViewControllers([VC1, VC2], animated: true)
    }
}

