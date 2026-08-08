//
//  ServerManager.swift
//  LANStream
//
//  Created by Amay Raj Srivastav on 29/07/26.
//

import Foundation
import Vapor
internal import Combine
import Leaf


@MainActor
class ServerManager: ObservableObject{
    @Published var isRunning = false
    private var app: Application?
    
    func start(){
        guard app == nil else {return}
        let env = try! Environment.detect()
        
        let newApp = Application(env)
        
        //Configuration
        newApp.http.server.configuration.hostname = "0.0.0.0"
        newApp.http.server.configuration.port = 8080
        
        
        
        if let resourcePath = Bundle.main.resourcePath{
            newApp.leaf.configuration.rootDirectory = resourcePath + "/Resources/Views/"
        }
        newApp.views.use(.leaf)
        
        
        do{
//            try newApp.middleware.use(FileMiddleware(bundle: Bundle.main))
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path()
            newApp.middleware.use(FileMiddleware(publicDirectory: documentsPath))
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
