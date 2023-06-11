//
//  IntroduceGame1.swift
//  FinalGame
//
//  Created by Abby on 2023/5/27.
//

import SwiftUI
import FirebaseFirestore

struct IntroduceGame1View: View {
    @State private var isWhite = true
    @State private var index = 0
    @State private var temp = false
    @State private var isStart = false
    @State private var RoomID = "1234"
    @State private var text = "Tap to get ready"
    @State private var Rule = RuleText()
    @State private var player = players()
    @State private var Opplayer = players()
    @State private var room = rooms()
    @EnvironmentObject var MyData : PlayersData
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                HStack{
                    VStack{
                        Image(Opplayer.role)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200,height: 200)
                        Text(Opplayer.name)
                            .foregroundColor(.white)
                            .font(.custom("Ayamikan", size: 30))
                    }
                    Spacer()
                    VStack{
                        Text("Game1")
                            .foregroundColor(.white)
                            .font(.custom("galivanted", size: 100))
                            .padding(.bottom)
                        Button {
                            text = "Wait for opponent"
                            if player.isPlayer1 {
                                room.Player1Ready = true
                                room.GameReady1(RoomID: RoomID, ok: true)
                            } else {
                                room.Player2Ok = true
                                room.GameReady2(RoomID: RoomID, ok: true)
                            }
                        } label: {
                            Text(text)
                                .foregroundColor(isWhite ? Color.white : Color.black)
                                .font(.custom("Ayamikan", size: 30))
                        }
                        .onAppear{
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                                withAnimation {
                                    isWhite.toggle()
                                }
                            }
                        }

                    }
                    Spacer()
                    VStack{
                        Image(player.role)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200,height: 200)
                        Text(player.name)
                            .foregroundColor(.white)
                            .font(.custom("Ayamikan", size: 30))
                    }
                    
                }
                HStack{
                    Button {
                        if index > 0{
                            index -= 1
                        }
                    } label: {
                        Image(systemName: "arrowtriangle.backward.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.orange)
                            .frame(width: 50,height: 50)
                        
                    }
                    ZStack{
                        Image("opacity")
                            .resizable()
                            .frame(width: 500,height: 130)
                            .opacity(0.4)
                        Text(Rule.Game1[index])
                            .foregroundColor(.white)
                            .font(.custom("Ayamikan", size: 30))
                    }
                    Button {
                        if index < 3{
                            index += 1
                        }
                    } label: {
                        Image(systemName: "arrowtriangle.forward.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.orange)
                            .frame(width: 50,height: 50)
                    }

                }
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
                        Opplayer.fetchPlayer(PlayerID: room.player[0] == MyData.MyID ? room.player[1] : room.player[0]) { opp in
                            Opplayer = opp ?? Opplayer
                        }
                    }
                }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2){
                let db = Firestore.firestore()
                db.collection("Rooms").document(player.currentRoom).addSnapshotListener { snapshot, error in
                        guard let snapshot else { return }
                        guard let roomdata = try? snapshot.data(as: rooms.self) else { return }
                        room = roomdata
                    if room.Player1Ready && room.Player2Ready{
                        isStart = true
                    }
                }
            }
        }
        
        .fullScreenCover(isPresented: $isStart) {
            WaitToStartView()
        }
    }
}

struct IntroduceGame1View_Previews: PreviewProvider {
    static var previews: some View {
        IntroduceGame1View()
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(PlayersData())
    }
}
