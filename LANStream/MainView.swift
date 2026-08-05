//
//  ContentView.swift
//  LANStream
//
//  Created by Amay Raj Srivastav on 29/07/26.
//

import SwiftUI

struct MainView: View {
    @StateObject private var server = ServerManager()
    var body: some View {
        VStack(spacing: 20) {
            Text(server.isRunning ? "Server Running 🟢" : "Server Stopped 🔴")
                .font(.headline)
            
            Button(server.isRunning ? "Stop Server" : "Start Server"){
                if(server.isRunning){
                    server.stop()
                }
                else{
                    server.start()
                    print("Fetched files List: \(fetchFilesList())")
                }
            }
            FilePickerView()
        }
        .padding()
        
    }
}

#Preview {
    MainView()
}
