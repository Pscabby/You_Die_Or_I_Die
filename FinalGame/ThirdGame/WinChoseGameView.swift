//
//  ChoseGameView.swift
//  FinalGame
//
//  Created by Abby on 2023/6/10.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

struct WinChoseGameView: View {
    @State private var player = players()
    @State private var Opplayer = players()
    @State private var room = rooms()
    @State private var chose = ChoseGame()
    @State private var pic = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    @State private var RoomID = "1234"
    @State private var jump = false
    @State private var PlayAgain = false
    @State private var Mplayer = AVPlayer()
    @State private var explosionScale: CGFloat = 1.0
    @State private var explosionOpacity: Double = 1.0
    @State private var opacity : Double = 0
    @Binding var Turn : String
    @EnvironmentObject var MyData : PlayersData
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .ignoresSafeArea()
                .opacity(0.5)
            HStack{
                VStack{
                    Image(Opplayer.role)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90,height: 90)
                        .offset(y:50)
                    Image("up3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100,height: 100)
                        .offset(y:30)
                        
                    if player.isPlayer1{
                        Image(pic[chose.Oppindex])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130,height: 130)
                            .offset(x:10,y:10)
                    }
                    else{
                        Image(pic[chose.Myindex])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130,height: 130)
                            .offset(x:10,y:10)
                    }
                    Image("down3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100,height: 100)
                        .offset(y:-10)
                        
                }.offset(x:-80)
                Image(pic[chose.Answer])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .saturation(0.0)
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(explosionScale)
                    .opacity(explosionOpacity)
                    .overlay {
                        Image("juice")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 500)
                            .opacity(opacity)
                    }
                    
                VStack{
                    Image(player.role)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90,height: 90)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                               .stroke(Color.blue, lineWidth: 5)
                               .shadow(radius: 3)
                        )
                        .offset(y:50)
                    Image("up3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100,height: 100)
                        .offset(y:30)
                    if player.isPlayer1{
                        Image(pic[chose.Myindex])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130,height: 130)
                            .offset(x:10,y:10)
                    } else {
                        Image(pic[chose.Oppindex])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130,height: 130)
                            .offset(x:10,y:10)
                    }
                    
                        Image("down3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100,height: 100)
                            .offset(y:-10)
                    }.offset(x:100)
                }
            }
            .onAppear{
                player.fetchPlayer(PlayerID: MyData.MyID) { playerdata in
                    print("playerdata: \(String(describing: playerdata?.id))")
                    player = playerdata ?? player
                    print("MyData: \(MyData.MyID)")
                    print("player.current: \(player.currentRoom)")
                    RoomID = player.currentRoom
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5){
                        room.fetchRoom(RoomID: player.currentRoom) { ID in
                            room = ID ?? room
                            print("room.id: \(String(describing: room.id))")
                            if room.player.count == 2 {
                                Opplayer.fetchPlayer(PlayerID: room.player[0] == MyData.MyID ? room.player[1] : room.player[0]) { opp in
                                    Opplayer = opp ?? Opplayer
                                }
                            }
                        }
                    }
                }

            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0) {
                    chose.fetchGame3(turn: Turn) { Chose in
                            chose = Chose ?? chose
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                    withAnimation {
                        explosionScale = 2.0
                        explosionOpacity = 0.0
                        opacity = 1
                        let url = Bundle.main.url(forResource: "juice", withExtension: "mp3")!
                                        let playerItem = AVPlayerItem(url: url)
                                        Mplayer.replaceCurrentItem(with: playerItem)
                                        Mplayer.play()
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
                    PlayAgain = true
                }
            }
            .fullScreenCover(isPresented: $PlayAgain) {
                WaitToStart3View()
            }
    }
}

//struct WinChoseGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        WinChoseGameView()
//            .previewInterfaceOrientation(.landscapeRight)
//            .environmentObject(PlayersData())
//    }
//}
