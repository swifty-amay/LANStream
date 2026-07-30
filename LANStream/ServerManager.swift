//
//  ServerManager.swift
//  LANStream
//
//  Created by Amay Raj Srivastav on 29/07/26.
//

import Foundation
import Vapor
internal import Combine

@MainActor
class ServerManager: ObservableObject{
    @Published var isRunning = false
    private var app: Application?
    
    func start(){
        guard app == nil else {return}
        let env = try! Environment.detect()
        
        let newApp = Application(env)
        
        //Configuration
        newApp.http.server.configuration.hostname = "127.0.0.1"
        newApp.http.server.configuration.port = 8080
        
        
        
        do{
            try newApp.middleware.use(FileMiddleware(bundle: Bundle.main))
            try routes(newApp)
        } catch{
            print("\(error)")
        }
        
        
        self.app = newApp
        isRunning = true
        
        Task.detached{
            do{
                try await newApp.execute()
            } catch{
                print("Server failed: \(error)")
            }
        }
    }
        
        func stop(){
            guard let currentApp = app else {return}
            
            currentApp.shutdown()
            
            app = nil
            isRunning = false
        }
        
    
}
