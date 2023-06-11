//
//  LoseCountGameView.swift
//  FinalGame
//
//  Created by Abby on 2023/5/30.
//

import SwiftUI
import FirebaseFirestore
import AVFoundation

struct LoseCountGameView: View {
    @State private var Countgame = CountGame()
    @State private var ShowApple = false
    @State private var PlayAgain = false
    @State private var Mplayer = AVPlayer()
    @Binding var Turn : String
    @Binding var isPlayer1 : Bool
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.green,.blue]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
                .ignoresSafeArea()
                .opacity(0.3)
            HStack{
                VStack{
                    Image("deer")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90,height: 90)
                        .offset(x:120,y:60)
                    Image("up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100,height: 100)
                        .offset(x:120,y:60)
                    if isPlayer1{
                        Text("\(Countgame.OppCount)")
                            .font(.custom("Ayamikan", size: 70))
                            .offset(x:120,y:35)
                            .foregroundColor(Color.gray)
                    }
                    else{
                        Text("\(Countgame.MyCount)")
                            .font(.custom("Ayamikan", size: 70))
                            .offset(x:120,y:35)
                            .foregroundColor(Color.gray)
                    }
                    Image("down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100,height: 100)
                        .offset(x:120,y:-15)
                }
                Image("tree")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200,height: 200)
                    .offset(x:170,y:-50)
                    .overlay {
                        if ShowApple{
                            ForEach(Countgame.Apple1,id: \.self){ apple in
                                Image(apple.name)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 65,height: 65)
                                    .offset(x:apple.x,y:apple.y)
                                    .opacity(apple.opacity)
                                    .transition(.move(edge: .leading))
                            }
                        }
                    }
                Image("tree")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250,height: 250)
                    .offset(x:80,y:10)
                    .overlay {
                        if ShowApple{
                            ForEach(Countgame.Apple2,id: \.self){ apple in
                                Image(apple.name)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 65,height: 65)
                                    .offset(x:apple.x,y:apple.y)
                                    .opacity(apple.opacity)
                                    .transition(.move(edge: .leading))
                            }
                        }
                    }
                Image("tree")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150,height: 150)
                    .offset(x:-40,y:100)
                    .overlay {
                        if ShowApple{
                            ForEach(Countgame.Apple3,id: \.self){ apple in
                                Image(apple.name)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 65,height: 65)
                                    .offset(x:apple.x,y:apple.y)
                                    .opacity(apple.opacity)
                                    .transition(.move(edge: .leading))
                            }
                        }
                    }
                Image("tree")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180,height: 180)
                    .offset(x:-140,y:-40)
                    .overlay {
                        if ShowApple{
                            ForEach(Countgame.Apple4,id: \.self){ apple in
                                Image(apple.name)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 65,height: 65)
                                    .offset(x:apple.x,y:apple.y)
                                    .opacity(apple.opacity)
                                    .transition(.move(edge: .leading))
                            }
                        }
                    }
                VStack {
                    Image("fox")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90,height: 90)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: 5)
                                .shadow(radius: 3)
                        )
                        .offset(x:-90,y:60)
                    Image("up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100,height: 100)
                        .offset(x:-90,y:60)
                    if isPlayer1{
                        Text("\(Countgame.MyCount)")
                            .font(.custom("Ayamikan", size: 70))
                            .offset(x:-90,y:35)
                            .foregroundColor(Color.blue)
                    }
                    else{
                        Text("\(Countgame.OppCount)")
                            .font(.custom("Ayamikan", size: 70))
                            .offset(x:-90,y:35)
                            .foregroundColor(Color.blue)
                    }
                    Image("down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100,height: 100)
                        .offset(x:-90,y: -15)
                }
            }
        }.onAppear{
            let db = Firestore.firestore()
            let documentReference = db.collection("Game1").document(Turn)
            documentReference.getDocument { document, error in
                guard let document,
                      document.exists,
                      var count = try? document.data(as: CountGame.self)
                else{
                    return
                }
                Countgame = count
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1){
                withAnimation {
                    ShowApple = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3){
                withAnimation {
                    ShowApple = false
                }
                
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+6){
                withAnimation {
                    PlayAgain = true
                }
            }
        }
        .onAppear {
            let url = Bundle.main.url(forResource: "lose", withExtension: "mp3")!
                            let playerItem = AVPlayerItem(url: url)
                            Mplayer.replaceCurrentItem(with: playerItem)
                            Mplayer.play()
        }
        .fullScreenCover(isPresented: $PlayAgain) {
            WaitToStartView()
        }
    }
}

//struct LoseCountGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoseCountGameView()
//            .previewInterfaceOrientation(.landscapeRight)
//    }
//}
