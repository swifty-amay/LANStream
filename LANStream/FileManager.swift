//
//  FileManager.swift
//  LANStream
//
//  Created by Amay Raj Srivastav on 01/08/26.
//

import Foundation


func importSelectedFiles(_ urls: [URL]) {
    //1. Getting the documentsDirectory url
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    
    for sourceURL in urls{
        let didStartAccessing = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing{
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }
        
        let destinationURL = documentURL.appendingPathComponent(sourceURL.lastPathComponent)
        
//        print("Source URL: \(sourceURL)")
//        print("Destination URL: \(destinationURL)")
        do{
            if FileManager.default.fileExists(atPath: destinationURL.path()){
                try FileManager.default.removeItem(at: destinationURL)
            } //if file already exist then remove it
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            print("Copied Succesfully")
        } catch{
            print("Failed to copy \(destinationURL.lastPathComponent): \(error)")
        }
        
    }
}


func clearDocumentDirectory(){
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    do{
        let fileURLs = try FileManager.default.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil)
        
        
        for fileURL in fileURLs{
            do{
                try FileManager.default.removeItem(at: fileURL)
            } catch{
                print("Failed to delete \(fileURL.lastPathComponent): \(error)")
            }
        }
        print("Cleared files in document Directory successfully")
        print("Contents in Document Directory after deletion: \(fileURLs)") //here this file url gives us the history of deleted files from previous stream
    
    } catch{
        print("Failed to list Documents Directory: \(error)")
    }
}

func fetchFilesList() -> [String]{
    var filesList: [String] = []
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    do{
        
        let files = try FileManager.default.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil)
        for file in files{
            let fileName = file.lastPathComponent
            filesList.append(fileName)
        }
    } catch{
        print("No files found")
    }
    return filesList
}

