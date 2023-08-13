import Foundation
import KeychainSwift

final class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() { }
    
    let keychain = KeychainSwift()
    
    func getUserPassword() -> String? {
        return keychain.get("password") ?? nil
    }
    
    func setUserPassword(password: String) {
        keychain.set(password, forKey: "password")
    }
    
    func clearKeys() {
        keychain.clear()
    }
}
