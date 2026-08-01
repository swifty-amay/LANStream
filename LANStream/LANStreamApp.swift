//
//  LANStreamApp.swift
//  LANStream
//
//  Created by Amay Raj Srivastav on 29/07/26.
//

import SwiftUI

@main
struct LANStreamApp: App {
    init(){
        clearDocumentDirectory()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
