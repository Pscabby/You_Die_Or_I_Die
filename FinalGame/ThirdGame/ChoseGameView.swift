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

struct ChoseGameView: View {
    @State private var player = players()
    @State private var Opplayer = players()
    @State private var room = rooms()
    @State private var chose = ChoseGame()
    @State private var Score = Game3Score()
    @State private var Turndata = Turn3Data()
    @State private var pic = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    @State private var RoomID = "1234"
    @State private var jump = false
    @State var looper: AVPlayerLooper?
    @State private var song = "furit"
    @State private var volume = 0.8
    @State private var fileUrl = Bundle.main.url(forResource: "furit", withExtension: "mp3")!
    @State private var Mplayer = AVQueuePlayer()
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
                    Button {
                        if player.isPlayer1 {
                            if chose.Myindex < 15{
                                chose.Myindex+=1
                                chose.ModifyMyIndex(Myindex: chose.Myindex, turn: Turn)
                            }
                        }
                        else {
                            if chose.Oppindex < 15{
                                chose.Oppindex+=1
                                chose.ModifyOppIndex(Oppindex: chose.Oppindex, turn: Turn)
                            }
                        }
                    } label: {
                        Image("up3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100,height: 100)
                    }.offset(y:30)
                    if player.isPlayer1{
                        Button {
                            if chose.Myindex == chose.Answer{
                                chose.isEnd = true
                                chose.SomeoneWin(turn: Turn)
                                Score.fetchScore { score in
                                    if var score = score {
                                            print("My Score: \(score.MyScore), Opponent Score: \(score.OppScore)")
                                        score.MyScore += 1
                                        Score.Addscore(my: score.MyScore, opp: score.OppScore)
                                        } else {
                                            print("Failed to fetch score")
                                        }
                                }
                                if Turndata.Myturn == "One"{
                                    Turndata.ChangeTurn(turn: "Two")
                                }
                                else if Turndata.Myturn == "Two"{
                                    Turndata.ChangeTurn(turn: "Three")
                                }
                            }
                            print("iscorrect: \(chose.isEnd)")
                        } label: {
                            Image(pic[chose.Myindex])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 130,height: 130)
                        }.offset(x:10,y:10)
                    } else {
                        Button {
                            if chose.Oppindex == chose.Answer{
                                chose.isEnd = true
                                chose.SomeoneWin(turn: Turn)
                                Score.fetchScore { score in
                                    if var score = score {
                                            print("My Score: \(score.MyScore), Opponent Score: \(score.OppScore)")
                                        score.OppScore += 1
                                        Score.Addscore(my: score.MyScore, opp: score.OppScore)
                                        } else {
                                            print("Failed to fetch score")
                                        }
                                }
                                if Turndata.Myturn == "One"{
                                    Turndata.ChangeTurn(turn: "Two")
                                }
                                else if Turndata.Myturn == "Two"{
                                    Turndata.ChangeTurn(turn: "Three")
                                }
                            }
                        } label: {
                            Image(pic[chose.Oppindex])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 130,height: 130)
                        }.offset(x:10,y:10)
                    }
                    Button {
                        if player.isPlayer1{
                            if chose.Myindex > 0 {
                                chose.Myindex -= 1
                                chose.ModifyMyIndex(Myindex: chose.Myindex, turn: Turn)
                            }
                        }
                        else{
                            if chose.Oppindex > 0 {
                                chose.Oppindex -= 1
                                chose.ModifyOppIndex(Oppindex: chose.Oppindex, turn: Turn)
                            }
                        }
                    } label: {
                        Image("down3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100,height: 100)
                            .offset(y:-10)
                    }
                }.offset(x:100)
            }
            .fullScreenCover(isPresented: $jump) {
                if Turn == "Three"{
                    StartCountGame3View()
                }
                else {
                    WinChoseGameView(Turn: $Turn)
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
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    if player.isPlayer1 {
                        chose.randomFurit(turn: Turn)
                    } else {
                        chose.fetchGame3(turn: Turn) { Chose in
                            chose = Chose ?? chose
                        }
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                    let db = Firestore.firestore()
                        db.collection("Game3").document(Turn).addSnapshotListener { snapshot, error in
                            guard let snapshot else { return }
                            guard let Chose = try? snapshot.data(as: ChoseGame.self) else { return }
                            chose = Chose
                        }
                }
            }
            .onAppear{
                Turndata.fetchTurn { MyTurn in
                    Turndata = MyTurn ?? Turndata
                }
            }
            .onAppear {
                fileUrl = Bundle.main.url(forResource: song, withExtension: "mp3")!
                let item = AVPlayerItem(url: fileUrl)
                self.looper = AVPlayerLooper(player: Mplayer , templateItem: item)
                Mplayer.play()
                //player.volume = Float(volume)
            }
            .onChange(of: chose.isEnd) { newValue in
                jump = newValue
                if jump {
                    Mplayer.pause()
                }
            }
        }
    }
}

//struct ChoseGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChoseGameView()
//            .previewInterfaceOrientation(.landscapeRight)
//            .environmentObject(PlayersData())
//    }
//}
