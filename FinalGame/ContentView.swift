//
//  ContentView.swift
//  FinalGame
//
//  Created by Abby on 2023/4/19.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ContentView: View {
    @StateObject var authen = Authentication()
    @StateObject private var MyData = PlayersData()
    var body: some View {
        if !authen.isLogin{
            LoginView(authen: authen)
                .environmentObject(MyData)
                .alert(isPresented: $authen.showAltert, content: {
                    Alert(title: Text("\(authen.alertTitle)"))
                })
        } else {
            MenuView()
                .environmentObject(MyData)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
