//
//  BoomGameView.swift
//  FinalGame
//
//  Created by Abby on 2023/5/28.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

struct BoomGameView: View {
    @State private var Boom = BoomGame()
    @State private var scale: Bool = false
    @State private var player = players()
    @State private var Opplayer = players()
    @State private var room = rooms()
    @State private var score = Game2Score()
    @State private var RoomID = "1234"
    @State private var jump = false
    @State var looper: AVPlayerLooper?
    @State private var song = "Boom"
    @State private var volume = 0.8
    @State private var fileUrl = Bundle.main.url(forResource: "Boom", withExtension: "mp3")!
    @State private var Mplayer = AVQueuePlayer()
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
                    .scaleEffect(player.isPlayer1 ? Boom.Oppscale : Boom.MyScale)
                Image(player.role)
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(270))
                    .frame(width: 200,height: 150)
                    .scaleEffect(player.isPlayer1 ? Boom.MyScale : Boom.Oppscale)
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
                            .scaleEffect(scale ? 1 : 1.3,anchor: .bottomLeading)
                        Button {
                            withAnimation {
                                scale.toggle()
                                if player.isPlayer1{
                                    Boom.MyCount += 1
                                    Boom.Oppscale += 0.05
                                    Boom.SetMyGame2(Mycount: Boom.MyCount, Oppscale: Boom.Oppscale)
                                    if Boom.MyCount > 20{
                                        score.fetchScore { Score in
                                            if var Score = Score {
                                                    print("My Score: \(Score.MyScore), Opponent Score: \(Score.OppScore)")
                                                Score.MyScore += 1
                                                score.Addscore(my: Score.MyScore, opp: Score.OppScore)
                                                } else {
                                                    print("Failed to fetch score")
                                                }
                                        }
                                        Boom.isEnd = true
                                        Boom.SomeoneWin()
                                    }
                                } else{
                                    Boom.OppCount += 1
                                    Boom.MyScale += 0.05
                                    Boom.SetOppGame2(Oppcount: Boom.OppCount, Myscale: Boom.MyScale)
                                    if Boom.OppCount > 20{
                                        score.fetchScore { Score in
                                            if var Score = Score {
                                                    print("My Score: \(Score.MyScore), Opponent Score: \(Score.OppScore)")
                                                Score.OppScore += 1
                                                score.Addscore(my: Score.MyScore, opp: Score.OppScore)
                                                } else {
                                                    print("Failed to fetch score")
                                                }
                                        }
                                        Boom.isEnd = true
                                        Boom.SomeoneWin()
                                    }
                                }
                            }
                        } label: {
                            Image("inflator_down")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(-90))
                                .frame(width: 110)
                                .offset(x:-40,y:-15)
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $jump, content: {
            StartCountGame2View()
        })
        .onAppear{
            Boom.fetchGame2 { BoomData in
                Boom = BoomData ?? Boom
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1){
                let db = Firestore.firestore()
                    db.collection("Game2").document("Boom").addSnapshotListener { snapshot, error in
                        guard let snapshot else { return }
                        guard let boom = try? snapshot.data(as: BoomGame.self) else { return }
                        Boom = boom
                        print("MyScore: \(Boom.MyCount)")
                        if Boom.isEnd {
                            jump = true
                            Mplayer.pause()
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
        .onAppear {
            fileUrl = Bundle.main.url(forResource: song, withExtension: "mp3")!
            let item = AVPlayerItem(url: fileUrl)
            self.looper = AVPlayerLooper(player: Mplayer , templateItem: item)
            Mplayer.play()
            //player.volume = Float(volume)
        }
    }
}

struct BoomGameView_Previews: PreviewProvider {
    static var previews: some View {
        BoomGameView()
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(PlayersData())
    }
}
