//
//  CountGameView.swift
//  FinalGame
//
//  Created by Abby on 2023/5/17.
//

import SwiftUI
import FirebaseFirestore
import AVFoundation

struct CountGameView: View {
    @State private var Countgame = CountGame()
    @State private var Score = Game1Score()
    @State private var Turndata = TurnData()
    @State private var player = players()
    @State private var Opplayer = players()
    @State private var RoomID = "1234"
    @State private var room = rooms()
    @State private var Win = false
    @State private var jump = false
    @State var looper: AVPlayerLooper?
    @State private var song = "Tree"
    @State private var volume = 0.8
    @State private var fileUrl = Bundle.main.url(forResource: "Tree", withExtension: "mp3")!
    @State private var Mplayer = AVQueuePlayer()
    @Binding var Turn : String
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
                    if player.isPlayer1{
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
                        ForEach(Countgame.Apple1,id: \.self){ apple in 
                            Image(apple.name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 65,height: 65)
                                .offset(x:apple.x,y:apple.y)
                                .opacity(apple.opacity)
                        }
                    }
                Image("tree")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250,height: 250)
                    .offset(x:80,y:10)
                    .overlay {
                        ForEach(Countgame.Apple2,id: \.self){ apple in
                            Image(apple.name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 65,height: 65)
                                .offset(x:apple.x,y:apple.y)
                                .opacity(apple.opacity)
                        }
                    }
                Image("tree")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150,height: 150)
                    .offset(x:-40,y:100)
                    .overlay {
                        ForEach(Countgame.Apple3,id: \.self){ apple in
                            Image(apple.name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 65,height: 65)
                                .offset(x:apple.x,y:apple.y)
                                .opacity(apple.opacity)
                        }
                    }
                Image("tree")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180,height: 180)
                    .offset(x:-140,y:-40)
                    .overlay {
                        ForEach(Countgame.Apple4,id: \.self){ apple in
                            Image(apple.name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 65,height: 65)
                                .offset(x:apple.x,y:apple.y)
                                .opacity(apple.opacity)
                        }
                    }
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
                    Button {
                        if player.isPlayer1 {
                            if Countgame.MyCount < 12{
                                Countgame.MyCount+=1
                                Countgame.ModifyMyCount(ChangeMycount: Countgame.MyCount, turn: Turn)
                            }
                        }
                        else {
                            if Countgame.OppCount < 12{
                                Countgame.OppCount+=1
                                Countgame.ModifyOppCount(ChangeOppcount: Countgame.OppCount, turn: Turn)
                            }
                        }
                    } label: {
                        Image("up")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100,height: 100)
                    }
                    .offset(x:-90,y:60)
                    
                    if player.isPlayer1{
                        Button {
                            if Countgame.MyCount == Countgame.total{
                                Countgame.iscorrect = true
                                Win = true
                                Countgame.ModifyEnd(ChangeEnd: Countgame.iscorrect, turn: Turn)
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
                            print("iscorrect: \(Countgame.iscorrect)")
                        } label: {
                            Text("\(Countgame.MyCount)")
                                .font(.custom("Ayamikan", size: 70))
                        }
                        .offset(x:-90,y:35)
                    }
                    else{
                        Button {
                            if Countgame.OppCount == Countgame.total{
                                Countgame.iscorrect = true
                                Win = true
                                Countgame.ModifyEnd(ChangeEnd: Countgame.iscorrect, turn: Turn)
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
                            print("iscorrect: \(Countgame.iscorrect)")
                        } label: {
                            Text("\(Countgame.OppCount)")
                                .font(.custom("Ayamikan", size: 70))
                        }
                        .offset(x:-90,y:35)
                    }
                    
                    Button {
                        if player.isPlayer1{
                            if Countgame.MyCount > 0 {
                                Countgame.MyCount-=1
                                Countgame.ModifyMyCount(ChangeMycount: Countgame.MyCount, turn: Turn)
                            }
                        }
                        else{
                            if Countgame.OppCount > 0 {
                                Countgame.OppCount-=1
                                Countgame.ModifyOppCount(ChangeOppcount: Countgame.OppCount, turn: Turn)
                            }
                        }
                    } label: {
                        
                        Image("down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100,height: 100)
                    }
                    .offset(x:-90,y: -15)
                }
            }
            
        }.fullScreenCover(isPresented: $jump) {
            if Turn == "Three"{
                StartCountGameView()
            }
            else {
                if Win{
                    WinCountGameView(Turn: $Turn, isPlayer1: $player.isPlayer1)
                } else {
                    LoseCountGameView(Turn: $Turn, isPlayer1: $player.isPlayer1)
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
            if player.isPlayer1{
                Countgame.randomnumber()
                Countgame.AddGame1(count1: Countgame.count1, count2: Countgame.count2, count3: Countgame.count3, count4: Countgame.count4, total: Countgame.total, Mycount: Countgame.MyCount, Oppcount: Countgame.OppCount, turn: Turn)
                Countgame.ChoseApple()
                Countgame.UpdateApple(turn: Turn)
            } else {
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
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1){
                let db = Firestore.firestore()
                    db.collection("Game1").document(Turn).addSnapshotListener { snapshot, error in
                        guard let snapshot else { return }
                        guard let count = try? snapshot.data(as: CountGame.self) else { return }
                        Countgame = count
                    }
            }
        }
        .onAppear{
            Turndata.fetchTurn { MyTurn in
                Turndata = MyTurn ?? Turndata
            }
        }
        .onChange(of: Countgame.iscorrect) { newValue in
            jump = newValue
            if jump {
                Mplayer.pause()
            }
        }
        .onAppear {
            fileUrl = Bundle.main.url(forResource: song, withExtension: "mp3")!
            let item = AVPlayerItem(url: fileUrl)
            self.looper = AVPlayerLooper(player: Mplayer , templateItem: item)
            Mplayer.play()
            //player.volume = Float(volume)
        }
    }
}

//struct CountGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        CountGameView()
//            .previewInterfaceOrientation(.landscapeRight)
//    }
//}
