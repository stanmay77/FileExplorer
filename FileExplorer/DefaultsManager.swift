import Foundation
import KeychainSwift

final class DefaultsManager {
    
    static let shared = DefaultsManager()
    
    private init() { }
    
    
    func save(items: [Settings]) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.setValue(data, forKey: "settings")
        }
    }
    
    func retrieve() -> [Settings] {
        if let data = try? UserDefaults.standard.data(forKey: "settings") {
            return (try? JSONDecoder().decode([Settings].self, from: data)) ?? []
        }
        else {
            return []
        }
    }
    
}
