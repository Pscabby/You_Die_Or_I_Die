//
//  WaitToStartView.swift
//  FinalGame
//
//  Created by Abby on 2023/5/30.
//

import SwiftUI
import FirebaseFirestore

struct WaitToStart3View: View {
    @State private var number = "3"
    @State private var isStart = false
    @State private var Turn = "One"
    @State private var RoomID = "1234"
    @State private var pic = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    @State private var chose = ChoseGame()
    @State private var Turndata = Turn3Data()
    @State private var player = players()
    @State private var Opplayer = players()
    @State private var room = rooms()
    @EnvironmentObject var MyData : PlayersData
    var body: some View {
        ZStack{
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
                    Image(pic[0])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130,height: 130)
                        .offset(x:10,y:10)
                    Image("down3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100,height: 100)
                        .offset(y:-10)
                        
                }.offset(x:-80)
                Image(pic[5])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .saturation(0.0)
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
                    Image(pic[0])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130,height: 130)
                        .offset(x:10,y:10)
                    Image("down3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100,height: 100)
                        .offset(y:-10)
                        
                }.offset(x:100)
            }
        }.opacity(0.6)
            .overlay {
                Text(number)
                    .font(.custom("Ayamikan", size: 150))
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
                            room.GameReady2(RoomID: RoomID, ok: false)
                            room.GameReady1(RoomID: RoomID, ok: false)
                            Opplayer.fetchPlayer(PlayerID: room.player[0] == MyData.MyID ? room.player[1] : room.player[0]) { opp in
                                Opplayer = opp ?? Opplayer
                            }
                        }
                    }
                }
            }
            .onAppear{
                Turndata.fetchTurn { MyTurn in
                    Turn = MyTurn?.Myturn ?? "One"
                }
                player.fetchPlayer(PlayerID: MyData.MyID) { players in
                    player = players ?? player
                }
                print("Turn: \(Turn)")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1){
                        number = "2"
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2){
                        number = "1"
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3){
                        isStart = true
                    }
                }
                .fullScreenCover(isPresented: $isStart) {
                    ChoseGameView(Turn: $Turn)
                }
    }
}

struct WaitToStart3View_Previews: PreviewProvider {
    static var previews: some View {
        WaitToStart3View()
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(PlayersData())
    }
}
