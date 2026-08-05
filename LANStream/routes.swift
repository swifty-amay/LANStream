//
//  routes.swift
//  LANStream
//
//  Created by Amay Raj Srivastav on 29/07/26.
//

import Foundation
import Vapor

func routes(_ app: Application) throws{
    
    app.get("hello"){req -> String in
        "Hello Everyone! This is swifty-amay's backend. Welcome to the Vapor world."
    }
    
    app.get("leaf"){req -> View in
        return try await req.view.render("hello", ["name": "Leaf"])
    }
    
}
