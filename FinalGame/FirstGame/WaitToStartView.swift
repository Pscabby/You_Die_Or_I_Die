//
//  WaitToStartView.swift
//  FinalGame
//
//  Created by Abby on 2023/5/30.
//

import SwiftUI
import FirebaseFirestore

struct WaitToStartView: View {
    @State private var Countgame = CountGame()
    @State private var Turndata = TurnData()
    @State private var number = "3"
    @State private var isStart = false
    @State private var Turn = "One"
    @State private var player = players()
    @State private var Opplayer = players()
    @State private var room = rooms()
    @State private var RoomID = "1234"
    @EnvironmentObject var MyData : PlayersData
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.green,.blue]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
                .ignoresSafeArea()
                .opacity(0.3)
            HStack{
                VStack{
                    Image(Opplayer.role)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90,height: 90)
                        .offset(x:120,y:60)
                    Image("up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100,height: 100)
                        .offset(x:120,y:60)
                    Text("0")
                        .font(.custom("Ayamikan", size: 70))
                        .offset(x:120,y:35)
                        .foregroundColor(Color.gray)
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
                Image("tree")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250,height: 250)
                    .offset(x:80,y:10)
                Image("tree")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150,height: 150)
                    .offset(x:-40,y:100)
                Image("tree")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180,height: 180)
                    .offset(x:-140,y:-40)
                VStack {
                    Image(player.role)
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
                    Text("0")
                            .font(.custom("Ayamikan", size: 70))
                            .offset(x:-90,y:35)
                            .foregroundColor(Color.blue)
                    Image("down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100,height: 100)
                        .offset(x:-90,y: -15)
                }
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
                            if player.isPlayer1 {
                                room.GameReady2(RoomID: RoomID, ok: false)
                                room.GameReady1(RoomID: RoomID, ok: false)
                            }
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
                    CountGameView(Turn: $Turn)
                }
    }
}

struct WaitToStartView_Previews: PreviewProvider {
    static var previews: some View {
        WaitToStartView()
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(PlayersData())
    }
}
