import UIKit
import MobileCoreServices
import Foundation


class FolderViewController: UIViewController {
    
    var settings = DefaultsManager.shared.retrieve()
    public var model = Model(sandboxFolder: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "fileCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(sortSettingsChanged), name: Notification.Name("sortSettingsChanged"), object: nil)
        
        
    }
       
    
    func configureUI() {
        
        view.backgroundColor = .systemBackground
        title = model.sandboxFolder.lastPathComponent
        
        let addFolderBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFolderPressed))
        let addImageBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addImagePressed))

        
        if self.parent != nil {
            self.parent?.navigationItem.rightBarButtonItems = [addFolderBarButton, addImageBarButton]
            self.parent?.navigationItem.hidesBackButton = true
        }

        navigationItem.rightBarButtonItems = [addFolderBarButton, addImageBarButton]

    
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
            
    }
    
    
    @objc func addFolderPressed() {
        
        let alertVC = UIAlertController(title: "Enter folder name", message: nil, preferredStyle: .alert)
        alertVC.addTextField()

        let submitAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            let folderName = alertVC.textFields![0].text ?? ""
            model.createDir(folderName)
            tableView.reloadData()
            }

            alertVC.addAction(submitAction)
            present(alertVC, animated: true)
        
    }
    
    @objc func addImagePressed() {
        let imageMediaType = kUTTypeImage as String
        let pickerVC = UIImagePickerController()
        pickerVC.sourceType = .photoLibrary
        pickerVC.mediaTypes = [imageMediaType]
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .fullScreen
        present(pickerVC, animated: true)
        
    }
    
    @objc func sortSettingsChanged() {
        
        print("Received update!")
        tableView.reloadData()
        
    }

}



extension FolderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath)
        var config = UIListContentConfiguration.cell()
        
        config.text = model.items[indexPath.row].lastPathComponent
        
        var isDirectory: ObjCBool = true
        FileManager.default.fileExists(atPath:  model.items[indexPath.row].path, isDirectory: &isDirectory)
        
        if model.checkForDir(indexPath.row) {
            config.secondaryText = "FOLDER"
        } else {
            config.secondaryText = "file"
        }
        
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if model.checkForDir(indexPath.row) {
            let vc = FolderViewController()
            vc.model = Model(sandboxFolder: model.items[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            model.deleteFile(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
}

extension FolderViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            model.writeImageFile(name: imageURL.lastPathComponent, data: imageData)
        }
        catch {
            print(error.localizedDescription)
        }
        
        picker.dismiss(animated: true)
        tableView.reloadData()
        }
    
}


