//
//  BackUpService.swift
//  Shared
//
//  Created by kankan on 4/05/20.
//  Copyright © 2020 queuesafe. All rights reserved.
//

import Foundation

public class BackUpService {
    
    public static func saveObjectToFile<T: Codable>(fileName: String, object: T) {
        let fullPath = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: fullPath)
        } catch {
        }
    }
    
    public static func readObjectFromFile<T: Codable>(fileName: String) -> T? {
         let fullPath = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: fullPath)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
        }
        return nil
    }
    
    public static func deleteFile(fileName: String) {
        let fullPath = getDocumentsDirectory().appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: fullPath)
    }
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
