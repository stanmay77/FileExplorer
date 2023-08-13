import Foundation


struct Model {
    
    var sandboxFolder: URL
    
    init(sandboxFolder: URL) {
        self.sandboxFolder = sandboxFolder
    }
    
    
    var items:[URL] {
        
        let sort1Option = DefaultsManager.shared.retrieve()[0].isChecked
        let sort2Option = DefaultsManager.shared.retrieve()[1].isChecked
            
        if sort1Option {
            return (try? FileManager.default.contentsOfDirectory(at: sandboxFolder, includingPropertiesForKeys: nil).sorted(by: { $1.lastPathComponent > $0.lastPathComponent})) ?? []
        } else if sort1Option {
            return (try? FileManager.default.contentsOfDirectory(at: sandboxFolder, includingPropertiesForKeys: nil).sorted(by: { $0.lastPathComponent > $1.lastPathComponent})) ?? []
        }
        
        return (try? FileManager.default.contentsOfDirectory(at: sandboxFolder, includingPropertiesForKeys: nil)) ?? []
    }
    
    
    func createDir(_ dir: String) {
        try? FileManager.default.createDirectory(at: sandboxFolder.appending(path: dir), withIntermediateDirectories: true)
    }
    
    func writeImageFile(name: String, data: Data) {
        try? data.write(to: sandboxFolder.appending(path: name))
        
    }
    
    func checkForDir(_ index: Int) -> Bool {
        var isDirectory: ObjCBool = true
        FileManager.default.fileExists(atPath: self.items[index].path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    
    func deleteFile(_ index: Int) -> Bool {
        ((try? FileManager.default.removeItem(at: self.items[index])) != nil)
    }
    
    
}


struct Settings: Codable, Equatable {
    
    var settingName: String
    var isChecked: Bool
    
    
    init(settingName: String, isChecked: Bool) {
        self.settingName = settingName
        self.isChecked = isChecked
    }
        
}
