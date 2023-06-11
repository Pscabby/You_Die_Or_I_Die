//
//  StartCountGame.swift
//  FinalGame
//
//  Created by Abby on 2023/5/26.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

struct FinalCountView: View {
    @State private var MyScore:Int = 0
    @State private var OppScore:Int = 0
    @State private var later:Double = 0
    @State private var IsPlayer1Win = false
    @State private var IsPlayer2Win = false
    @State private var RoomID = "1234"
    @State private var Mplayer = AVQueuePlayer()
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
                    ZStack {
                        if IsPlayer2Win{
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 12, height: 12)
                                .modifier(ParticlesModifier())
                                .offset(x: -100, y : -50)
                            
                            Circle()
                                .fill(Color.red)
                                .frame(width: 12, height: 12)
                                .modifier(ParticlesModifier())
                                .offset(x: 60, y : 70)
                        }
                        VStack{
                            Image("crown")
                                .resizable()
                                .scaledToFit()
                                .offset(x:0,y: 0)
                                .opacity(IsPlayer2Win ? 1 : 0)
                                .transition(.scale)
                            Image(player.isPlayer1 ? Opplayer.role : player.role)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200,height: 200)
                                .offset(x:0,y:-70)
                            Text(player.isPlayer1 ? Opplayer.name : player.name)
                                .foregroundColor(.white)
                                .font(.custom("Ayamikan", size: 30))
                                .offset(x:0,y: -60)
                        }
                    }
                    Spacer()
                    VStack{
                        Text("Final")
                            .foregroundColor(.white)
                            .font(.custom("galivanted", size: 100))
                            .padding(.bottom)
                        HStack{
                            VStack{
                                Text("Score")
                                    .foregroundColor(.white)
                                    .font(.custom("Ayamikan", size: 40))
                                Text("\(OppScore)")
                                    .foregroundColor(.white)
                                    .font(.custom("Ayamikan", size: 40))
                                    .animation(.linear(duration: 1), value: OppScore)
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5){
                                            later = 0
                                            for i in 0..<room.Player2Score{
                                                later += 0.6
                                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+later){
                                                    withAnimation{
                                                        OppScore += 1
                                                        print(OppScore)
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                            }
                            Spacer()
                            VStack{
                                Text("Score")
                                    .foregroundColor(.white)
                                    .font(.custom("Ayamikan", size: 40))
                                Text("\(MyScore)")
                                    .foregroundColor(.white)
                                    .font(.custom("Ayamikan", size: 40))
                                    .animation(.linear(duration: 1), value: MyScore)
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5){
                                            later = 0
                                            for i in 0..<room.Player1Score{
                                                later += 0.6
                                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+later){
                                                    withAnimation{
                                                        MyScore += 1
                                                        print(MyScore)
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    Spacer()
                    ZStack {
                        if IsPlayer1Win{
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 12, height: 12)
                                .modifier(ParticlesModifier())
                                .offset(x: -100, y : -50)
                            
                            Circle()
                                .fill(Color.red)
                                .frame(width: 12, height: 12)
                                .modifier(ParticlesModifier())
                                .offset(x: 60, y : 70)
                        }
                        VStack{
                            Image("crown")
                                .resizable()
                                .scaledToFit()
                                .offset(x:40,y: 0)
                                .opacity(IsPlayer1Win ? 1 : 0)
                                .transition(.scale)
                            Image(player.isPlayer1 ? player.role : Opplayer.role)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200,height: 200)
                                .offset(x:0,y: -50)
                            Text(player.isPlayer1 ? player.name : Opplayer.name)
                                .foregroundColor(.white)
                                .font(.custom("Ayamikan", size: 30))
                                .offset(x:0,y: -60)
                        }
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+4) {
                withAnimation {
                    if room.Player1Score > room.Player2Score {
                        IsPlayer1Win = true
                    } else {
                        IsPlayer2Win = true
                    }
                }
            }
            let url = Bundle.main.url(forResource: "fire", withExtension: "mp3")!
                            let playerItem = AVPlayerItem(url: url)
                            Mplayer.replaceCurrentItem(with: playerItem)
                            Mplayer.play()
        }
    }
}

struct FinalCount_Previews: PreviewProvider {
    static var previews: some View {
        FinalCountView()
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(PlayersData())
    }
}
