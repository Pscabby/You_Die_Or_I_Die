//
//  BoomGameView.swift
//  FinalGame
//
//  Created by Abby on 2023/5/28.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct WaitToStart2View: View {
    @State private var player = players()
    @State private var Opplayer = players()
    @State private var room = rooms()
    @State private var RoomID = "1234"
    @State private var number = "3"
    @State private var isStart = false
    @EnvironmentObject var MyData : PlayersData
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.pink,.yellow]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
                .ignoresSafeArea()
                .opacity(0.3)
            Image("boom")
                .resizable()
                .scaledToFit()
                .frame(width: 1600)
                .opacity(0.4)
            HStack{
                VStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.blue.opacity(0.7))
                        .frame(width: 170,height: 80)
                        .overlay {
                            Text(Opplayer.name)
                                .font(.custom("Ayamikan", size: 30))
                        }.offset(x:30,y:-60)
                    HStack{
                        Image("inflator_down")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(90))
                            .frame(width: 110)
                            .offset(x:70,y:0)
                        Image("inflator_up")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(90))
                            .frame(width: 115)
                            .offset(x:3,y: 0)
                            .scaleEffect(1.3,anchor: .bottomLeading)
                    }
                }
                Image(Opplayer.role)
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(90))
                    .frame(width: 200,height: 150)
                    .scaleEffect(0.8)
                Image(player.role)
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(270))
                    .frame(width: 200,height: 150)
                    .scaleEffect(0.8)
                VStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.pink.opacity(0.7))
                        .frame(width: 170,height: 80)
                        .overlay {
                            Text(player.name)
                                .font(.custom("Ayamikan", size: 30))
                        }.offset(x:-10,y:-60)
                    HStack{
                        Image("inflator_up")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(-90))
                            .frame(width: 115)
                            .offset(x:-5,y: 0)
                            .scaleEffect(1.3,anchor: .bottomLeading)
                        Image("inflator_down")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(-90))
                            .frame(width: 110)
                            .offset(x:-40,y:-15)
                    }
                }
            }
        }.opacity(0.6)
        .overlay {
                Text(number)
                    .font(.custom("Ayamikan", size: 150))
        }
        .onAppear{
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
            BoomGameView()
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
    }
}

struct WaitToStart2View_Previews: PreviewProvider {
    static var previews: some View {
        WaitToStart2View()
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(PlayersData())
    }
}
