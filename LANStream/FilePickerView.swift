//
//  FilePickerView.swift
//  LANStream
//
//  Created by Amay Raj Srivastav on 31/07/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct FilePickerView: View {
    
    @State private var showFileImporter = false

    var body: some View {
        Button{
            showFileImporter = true
        } label: {
            Label("Choose file to import", systemImage: "doc.circle")
                .font(.title)
        }
        .buttonStyle(.glass)
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.item],
            allowsMultipleSelection: true,
            onCompletion: {result in
                switch result {
                case .success(let files):
                    importSelectedFiles(files)
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    private func importSelectedFiles(_ urls: [URL]) {
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
}

#Preview {
    FilePickerView()
}
