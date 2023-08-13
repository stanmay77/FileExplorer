import UIKit
import MobileCoreServices
import Foundation

class SettingsViewController: UIViewController {
    
    var settings = DefaultsManager.shared.retrieve()
    
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
        table.register(UITableViewCell.self, forCellReuseIdentifier: "newUserCell")
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        
    }
    
    func configureUI() {
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        title = "Настройки"
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return settings.count
        } else {
            return 1
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Настройка сортировки"
        } else
        {
            return "Настройки пользователя"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
            var config = UIListContentConfiguration.cell()
            config.text = settings[indexPath.row].settingName
            
            if settings[indexPath.row].isChecked {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            cell.contentConfiguration = config
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newUserCell", for: indexPath)
            var config = UIListContentConfiguration.cell()
            config.text = "Поменять пароль"
            cell.contentConfiguration = config
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            settings[indexPath.row].isChecked.toggle()
            if indexPath.row == 1 && settings[indexPath.row].isChecked {
                settings[indexPath.row-1].isChecked = false
            } else if indexPath.row == 0 && settings[indexPath.row].isChecked {
                settings[indexPath.row+1].isChecked = false
            }
            
            DefaultsManager.shared.save(items: settings)
            settings = DefaultsManager.shared.retrieve()
            print(settings[indexPath.row].isChecked)
            
            NotificationCenter.default.post(name: Notification.Name("sortSettingsChanged"), object: nil)
            
            tableView.reloadData()
        }
        
        else {
            let viewModel = StartViewModel()
            let vc = StartViewController(viewModel: viewModel)
            viewModel.state = .notRegistered
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }

    
}

