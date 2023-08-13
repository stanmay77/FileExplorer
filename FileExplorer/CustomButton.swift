import UIKit


final class CustomButton: UIButton {
    
    typealias Action = (()->Void)
    var action: Action
    
    var title: String = ""
    var titleColor: UIColor? = nil
    var bgColor: UIColor? = nil
    var cornerRadius: Float = 0
    
    init(frame: CGRect, title: String, titleColor: UIColor?, bgColor: UIColor?, cornerRadius: Float, action: @escaping (()->Void)) {
        self.action = action
        super.init(frame: frame)
        self.title = title
        self.titleColor = titleColor
        self.bgColor = bgColor
        self.cornerRadius = cornerRadius
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI() {
        self.addTarget(self, action: #selector(doAction), for: .touchUpInside)
        self.setTitle(title, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(titleColor, for: .normal)
 //       self.backgroundColor = bgColor
        self.layer.borderColor = UIColor.link.cgColor
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        
        self.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
        self.setBackgroundImage(UIImage(named: "blue_pixel")!.image(alpha: 0.8), for: .selected)
        self.setBackgroundImage(UIImage(named: "blue_pixel")!.image(alpha: 0.8), for: .highlighted)
        self.setBackgroundImage(UIImage(named: "blue_pixel")!.image(alpha: 0.8), for: .disabled)
        self.clipsToBounds = true
    }
    
    enum Titles: String, RawRepresentable {
        case notRegitered = "Создать пароль"
        case confirmPassword = "Повторите пароль"
        case registered = "Введите пароль"
    }
    
    @objc func doAction() {
        action()
    }
    
}
