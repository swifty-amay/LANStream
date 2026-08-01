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
                    print(files)
                    importSelectedFiles(files)
                case .failure(let error):
                    print(error)
                }
            })
    }
    
}

#Preview {
    FilePickerView()
}
