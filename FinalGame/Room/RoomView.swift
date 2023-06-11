//
//  RoomView.swift
//  FinalGame
//
//  Created by Abby on 2023/6/7.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import AVFoundation

struct RoomView: View {
    @State private var bgColor1 = Color.purple
    @State private var pic = ["bear","Crocodile","deer","fox","hedgehog","meerkat","ocean","otter","panda","penguin","rabit","unicorn"]
    @State private var Index = 0
    @State private var jump = false
    @State private var room = rooms()
    @State private var player = players()
    @State private var Opplayer = players()
    @State private var RoomID = "1234"
    @State private var ready = "Ready!!"
    @State var looper: AVPlayerLooper?
    @State private var song = "Menu"
    @State private var volume = 0.8
    @State private var fileUrl = Bundle.main.url(forResource: "Menu", withExtension: "mp3")!
    @State private var Mplayer = AVQueuePlayer()
    @EnvironmentObject var MyData : PlayersData
    var body: some View {
        ZStack{
            Image("lobby")
                .resizable()
                .ignoresSafeArea()
                .opacity(0.5)
            HStack {
                VStack{
                    HStack {
                        ColorPicker("", selection: $bgColor1)
                            .offset(x:-40)
                        Button {
                            ready = "Waiting!!"
                            if player.isPlayer1 {
                                room.Player1Ok = true
                                room.Ready1Room(RoomID: RoomID, ok: true)
                            } else {
                                room.Player2Ok = true
                                room.Ready2Room(RoomID: RoomID, ok: true)
                            }
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1){
                                if room.Player1Ok && room.Player2Ok {
                                    room.StartRoom(RoomID: RoomID)
                                }
                            }
                        } label: {
                            Text(ready)
                                .font(.custom("Ayamikan", size: 40))
                        }.buttonStyle(.borderedProminent)
                        ZStack{
                            Image("flag")
                                .resizable()
                                .frame(width: 600,height: 200)
                                .overlay {
                                    VStack{
                                        Text("Room code:")
                                            .font(.custom("Ayamikan", size: 40))
                                        Text("\(RoomID)")
                                            .font(.custom("Ayamikan", size: 30))
                                    }.offset(y:-10)
                                }
                                .offset(x:-30)
                            VStack{
                                Text("Lobby")
                                    .font(.custom("Ayamikan", size: 70))
                                
                                Text("Online With Friends")
                                    .font(.custom("Ayamikan", size: 30))
                            }.offset(x:-350)
                                .foregroundColor(.pink)
                        }.offset(x:190,y:20)
                    }
                    
                    HStack{
                        if player.isPlayer1 {
                            Group{
                                Circle()
                                    .foregroundColor(bgColor1)
                                    .foregroundColor(bgColor1)
                                    .overlay {
                                        VStack{
                                            Image(player.role)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 180,height: 180)
                                            Text(player.name)
                                                .font(.custom("Ayamikan", size: 36))
                                        }
                                    }
                                Circle()
                                    .foregroundColor(Color.gray)
                                    .overlay {
                                        VStack{
                                            Image(Opplayer.role)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 180,height: 180)
                                            Text(Opplayer.name)
                                                .font(.custom("Ayamikan", size: 36))
                                        }
                                    }
                            }
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .frame(width: 240,height: 240)
                            .padding(.horizontal)
                            .offset(x:130,y:-35)
                        } else {
                            Group{
                                Circle()
                                    .foregroundColor(Color.gray)
                                    .overlay {
                                        VStack{
                                            Image(Opplayer.role)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 180,height: 180)
                                            Text(Opplayer.name)
                                                .font(.custom("Ayamikan", size: 36))
                                        }
                                    }
                                Circle()
                                    .foregroundColor(bgColor1)
                                    .overlay {
                                        VStack{
                                            Image(player.role)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 180,height: 180)
                                            Text(player.name)
                                                .font(.custom("Ayamikan", size: 36))
                                        }
                                    }
                            }
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .frame(width: 240,height: 240)
                            .padding(.horizontal)
                            .offset(x:130,y:-35)
                        }
                        Picker(selection: $Index) {
                            ForEach(pic.indices) { item in
                                HStack{
                                    Text("\(pic[item])")
                                    Image(pic[item])
                                        .resizable()
                                        .scaledToFit()
                                }
                               }
                        } label: {
                            Text("Pick a role!!")
                        }.pickerStyle(.wheel)
                            .offset(x:70)
                    }
                    .onChange(of: Index) { index in
                        player.ChangeRole(Role: pic[Index], PlayerID: MyData.MyID)
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
                        if room.player.count == 2 {
                            Opplayer.fetchPlayer(PlayerID: room.player[0] == MyData.MyID ? room.player[1] : room.player[0]) { opp in
                                Opplayer = opp ?? Opplayer
                            }
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
                    if room.player.count == 2 {
                        Opplayer.fetchPlayer(PlayerID: room.player[0] == MyData.MyID ? room.player[1] : room.player[0]) { opp in
                            Opplayer = opp ?? Opplayer
                        }
                    }
                    if room.gameState == "playing" {
                        jump = true
                        Mplayer.pause()
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2){
                let db = Firestore.firestore()
                db.collection("Players").document(MyData.MyID).addSnapshotListener { snapshot, error in
                        guard let snapshot else { return }
                        guard let playerdata = try? snapshot.data(as: players.self) else { return }
                        player = playerdata
                    }
            }
        }
        .onAppear{
            fileUrl = Bundle.main.url(forResource: song, withExtension: "mp3")!
            let item = AVPlayerItem(url: fileUrl)
            self.looper = AVPlayerLooper(player: Mplayer , templateItem: item)
            Mplayer.play()
        }
        .fullScreenCover(isPresented: $jump) {
            IntroduceGame1View()
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView()
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(PlayersData())
    }
}
