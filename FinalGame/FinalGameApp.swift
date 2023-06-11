//
//  FinalGameApp.swift
//  FinalGame
//
//  Created by Abby on 2023/4/19.
//

import SwiftUI
import Firebase

@main
struct FinalGameApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
