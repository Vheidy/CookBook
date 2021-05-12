//
//  ImageKeeperManager.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 12.05.2021.
//

import Foundation

class DataFileManager {
    
    func saveDataToDocuments(data: Data, withName name: String) {
        save(data: data, toDirectory: documentDirectory(), withFileName: name)
        print(read(fromDocumentsWithFileName: name))
    }
    
    func getPath(for name: String) -> String? {
        append(toPath: documentDirectory(), withPathComponent: name)
    }
    
     private func documentDirectory() -> String {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].absoluteString
    }
    
     private func append(toPath path: String, withPathComponent pathComponent: String) -> String? {
        guard var pathURL = URL(string: path) else { return nil }
        pathURL.appendPathComponent(pathComponent)
        return pathURL.absoluteString
    }
    
    
     func read(fromDocumentsWithFileName fileName: String) -> Data? {
        let appendedURL = append(toPath: documentDirectory(), withPathComponent: fileName)
        guard let filePath = appendedURL, let fileURL = URL(string: filePath) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return data
//            let image = UIImage(data: data)
//            let savedString = try String(contentsOfFile: filePath)
            
//            print(image)
        } catch {
            print("Error reading saved file")
        }
        return nil
    }
    
    
     private func save(data: Data, toDirectory directory: String, withFileName fileName: String) {
        guard let filePath = append(toPath: directory, withPathComponent: fileName),
              let fileURL = URL(string: filePath)
        else { return }
                
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error", error)
            return
        }
        
        print("Save successful")
    }
    
    
}
