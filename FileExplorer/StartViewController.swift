import UIKit
import Foundation

class StartViewController: UIViewController {

    var viewModel: AppViewModel
    
    let passwordField: UITextField = {
        let field = UITextField(frame: .zero)
        field.setLeftSpacer(of: 15)
        field.placeholder = "Пароль"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 10
        field.backgroundColor = .systemGray5
        field.autocapitalizationType = .none
        field.layer.borderColor = UIColor.systemMint.cgColor
        field.layer.borderWidth = 2
        field.addTarget(self, action: #selector(finishEditing), for: .editingChanged)
        return field
    }()
    
    
    
    lazy var proceedButton = CustomButton(frame: .zero, title: "", titleColor: .white, bgColor: .systemBlue, cornerRadius: 10) { [unowned self] in
        
        switch self.viewModel.state {
        case .hasPassword:
            if passwordField.text! == KeychainManager.shared.getUserPassword() {
                let folderTabsVC = UINavigationController(rootViewController: FolderTabViewController())
                folderTabsVC.modalPresentationStyle = .fullScreen
                present(folderTabsVC, animated: true)
            }
        case .notRegistered:
            self.viewModel.updateState(state: .confirmPassword(passwordField.text!))
            let confirmVC = StartViewController(viewModel: viewModel)
            confirmVC.modalPresentationStyle = .fullScreen
            present(confirmVC, animated: true)
            
         //   navigationController?.pushViewController(StartViewController(viewModel: viewModel), animated: true)
        case .confirmPassword(let passw):
            if passwordField.text! == passw {
                KeychainManager.shared.setUserPassword(password: passwordField.text!)
                let folderTabsVC = UINavigationController(rootViewController: FolderTabViewController())
                folderTabsVC.modalPresentationStyle = .fullScreen
                present(folderTabsVC, animated: true)
                
                //navigationController?.pushViewController(FolderTabViewController(), animated: true)
                //navigationController?.navigationBar.isHidden = false
            }
            else {
                let alertVC = UIAlertController(title: "Ошибка", message: "Пароли не совпадают", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Повторите ввод", style: .default))
                present(alertVC, animated: true)
            }

        }
        
        }
    
    
    init(viewModel: AppViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let passw = StorageManager.shared.getUserPassword() {
//            viewModel.updateState(state: .hasPassword)
//        } else {
//            viewModel.updateState(state: .notRegistered)
//        }
        
        configureUI()
        
    }
       
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func configureUI() {
        title = "Вход в сервис"
        view.backgroundColor = .systemBackground
        view.addSubview(passwordField)
        view.addSubview(proceedButton)
        passwordField.delegate = self
        proceedButton.isEnabled = false

        print(viewModel.state)
        
        
        switch viewModel.state {
        case .confirmPassword(let passw):
            proceedButton.setTitle(CustomButton.Titles.confirmPassword.rawValue, for: UIControl.State.normal)
        case .hasPassword:
            proceedButton.setTitle(CustomButton.Titles.registered.rawValue, for: UIControl.State.normal)
        case .notRegistered:
            proceedButton.setTitle(CustomButton.Titles.notRegitered.rawValue, for: UIControl.State.normal)
        }
        
        
        NSLayoutConstraint.activate([
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            passwordField.widthAnchor.constraint(equalToConstant: 250),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            
            proceedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            proceedButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 50),
            proceedButton.heightAnchor.constraint(equalToConstant: 40),
            proceedButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func checkInput() {
        print("check input")
    }

}

extension StartViewController: UITextFieldDelegate {
    
    @objc func finishEditing() {
        proceedButton.isEnabled = !passwordField.text!.isEmpty && (passwordField.text!.count > 3)
    }
}
