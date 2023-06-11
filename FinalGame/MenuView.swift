//
//  ContentView.swift
//  FinalGame
//
//  Created by Abby on 2023/4/19.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

struct MenuView: View {
    @State private var jump = false
    @State private var setting = false
    @State private var Score = false
    @State private var About = false
    @State private var Turn = "One"
    @State var looper: AVPlayerLooper?
    @State private var song = "Menu"
    @State private var volume = 0.8
    @State private var fileUrl = Bundle.main.url(forResource: "Menu", withExtension: "mp3")!
    @State private var player = AVQueuePlayer()
    @EnvironmentObject var MyData : PlayersData
    
    var body: some View {
        ZStack {
            Image("bg2")
                .resizable()
                .ignoresSafeArea()
                .opacity(0.7)
            HStack {
                Text("You Die\n   Or\n I Die!!")
                    .font(.custom("Little Zombie", size: 80))
                VStack{
                    HStack{
                        Button {
                            jump = true
                            player.pause()
                        } label: {
                            Text("Join With Friends")
                                .font(.custom("Ayamikan", size: 40))
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(40)
                                .foregroundColor(.white)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.purple, lineWidth: 5)
                                )
                        }.padding()
                        Button {
                            setting = true
                            player.pause()
                        } label: {
                            Text("Setting")
                                .font(.custom("Ayamikan", size: 40))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(40)
                                .foregroundColor(.purple)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.white, lineWidth: 5)
                                )
                        }.padding()

                    }

                    HStack{
                        Link(destination: URL(string: "https://medium.com/@ivyann209/8-final-game-you-die-or-i-die-c186b6650e8a")!, label: {
                            Text("About")
                                .font(.custom("Ayamikan", size: 40))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(40)
                                .foregroundColor(.purple)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.white, lineWidth: 5)
                                )
                        })
                        
                        Button {
                            Score = true
                            player.pause()
                        } label: {
                            Text("I am ScoreBoard")
                                .font(.custom("Ayamikan", size: 40))
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(40)
                                .foregroundColor(.white)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.purple, lineWidth: 5)
                                )
                        }.padding()
                    }
                    
                }.sheet(isPresented: $jump) {
                    ChoseRoomView()
                }
                .onAppear{
                    if AccountID() != "" {
                        MyData.MyID = AccountID()
                    }
                    print("MyData.MyID \(MyData.MyID)")
            }
                .onAppear {
                    fileUrl = Bundle.main.url(forResource: song, withExtension: "mp3")!
                    let item = AVPlayerItem(url: fileUrl)
                    self.looper = AVPlayerLooper(player: player , templateItem: item)
                    player.play()
                    //player.volume = Float(volume)
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(PlayersData())
    }
}
