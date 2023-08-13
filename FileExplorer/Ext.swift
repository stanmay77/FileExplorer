import UIKit


extension UITextField {
    
    func setLeftSpacer(of size: CGFloat) {
        let spacer = UIView(frame: CGRect(x: 0, y:0, width: size, height: self.frame.size.height))
        self.leftView = spacer
        self.leftViewMode = .always
    }
    
    
}


extension UIImage {
    
    func image(alpha: Double) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
