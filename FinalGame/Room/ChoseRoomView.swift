//
//  ChoseRoomView.swift
//  FinalGame
//
//  Created by Abby on 2023/6/8.
//

import SwiftUI
import AVFoundation

struct ChoseRoomView: View {
    @State private var RoomID = ""
    @State private var CreatID = ""
    @State private var jump = false
    @State private var showAlert = false
    @State var looper: AVPlayerLooper?
    @State private var song = "Menu"
    @State private var volume = 0.8
    @State private var fileUrl = Bundle.main.url(forResource: "Menu", withExtension: "mp3")!
    @State private var Mplayer = AVQueuePlayer()
    @State private var room = rooms()
    @State private var player = players()
    @EnvironmentObject var MyData : PlayersData
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.orange,.pink]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
                .ignoresSafeArea()
                .opacity(0.3)
            Image("grass")
                .offset(y:75)
                .opacity(0.7)
            VStack {
                Text("Join With Friends!!")
                    .font(.custom("Ayamikan", size: 50))
                    .foregroundColor(Color.purple)
                    .offset(y:40)
                HStack{
                    Button {
                        CreatID = room.CreatRoom(playerID: MyData.MyID)
                        player.EnterRoom(PlayerID: MyData.MyID, RoomID: CreatID, isPlayer1: true)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1){
                            jump = true
                            Mplayer.pause()
                        }
                    } label: {
                        Image("wood")
                            .resizable()
                            .frame(width: 400,height: 300)
                            .overlay {
                                Text("Creat a Room")
                                    .font(.custom("Ayamikan", size: 50))
                                    .offset(x:-20,y:-40)
                                    .foregroundColor(.white)
                            }
                    }
                    Image("wood2")
                        .resizable()
                        .frame(width: 300,height: 350)
                        .overlay {
                            VStack{
                                TextField("Room Number",text: $RoomID,prompt:Text("Room Number"))
                                    .padding()
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.yellow, lineWidth: 5)
                                    }
                                    .frame(width: 250)
                                Button {
                                    room.fetchRoom(RoomID: RoomID) { rooms in
                                        room = rooms ?? room
                                        if room.gameState == ""{
                                            showAlert = true
                                        }
                                        else {
                                            player.EnterRoom(PlayerID: MyData.MyID, RoomID: RoomID, isPlayer1: false)
                                            room.EnterRoom(playerID: MyData.MyID, RoomID: RoomID)
                                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5){
                                                jump = true
                                                Mplayer.pause()
                                            }
                                        }
                                    }
                                } label: {
                                    Text("Enter the Room")
                                        .font(.custom("Ayamikan", size: 50))
                                        .foregroundColor(.brown)
                                }

                            }
                            .offset(y:-80)
                        }
                        .offset(y:20)
                }
            }
        }
        .onAppear{
            fileUrl = Bundle.main.url(forResource: song, withExtension: "mp3")!
            let item = AVPlayerItem(url: fileUrl)
            self.looper = AVPlayerLooper(player: Mplayer , templateItem: item)
            Mplayer.play()
        }
        .alert("Room is not exit", isPresented: $showAlert) {
            Button("try again"){}
        }
        .fullScreenCover(isPresented: $jump) {
            RoomView()
        }
    }
}

struct ChoseRoomView_Previews: PreviewProvider {
    static var previews: some View {
        ChoseRoomView()
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(PlayersData())
    }
}
