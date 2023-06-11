//
//  LoginView.swift
//  FinalGame
//
//  Created by Abby on 2023/5/17.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import AVFoundation

struct LoginView: View {
    @ObservedObject var authen : Authentication
    @State private var showLogin: Bool = true // true: Log in, false: Sign up
    @State private var pic = ["bear","Crocodile","deer","fox","hedgehog","meerkat","ocean","otter","panda","penguin","rabit","unicorn"]
    @State private var Index = 0
    @EnvironmentObject var MyData : PlayersData
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.yellow,.pink]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
                .ignoresSafeArea()
                .opacity(0.3)
            HStack{
                VStack{
                    Image(pic[Index])
                        .resizable()
                        .scaledToFit()
                        .frame(width:250 ,height: 250)
                        .offset(x:-20,y:40)
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

                }.offset(x:25)
                    if showLogin{
                        LoginAccountView(authen: authen, showLogin: $showLogin)
                    }
                    else{
                        SignUpAccountView(authen: authen, showLogin: $showLogin)
                    }
            }
        }
    }
}

struct LoginAccountView: View{
    @ObservedObject var authen: Authentication
    @Binding var showLogin: Bool
    @State private var mail: String = ""
    @State private var password: String = ""
    @State var looper: AVPlayerLooper?
    @State private var song = "Menu"
    @State private var volume = 0.8
    @State private var fileUrl = Bundle.main.url(forResource: "Menu", withExtension: "mp3")!
    @State private var player = AVQueuePlayer()
    @EnvironmentObject var MyData : PlayersData
    var body: some View{
        ZStack {
            Image("bg1")
                .resizable()
                .frame(width: 450,height: 450)
                .opacity(0.6)
            VStack{
                ZStack {
                    Button {
                        showLogin = false
                        player.pause()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.blue
                                    .opacity(0.4))
                                .frame(width: 200, height: 60)
                            Text("Sign up")
                                .font(.custom("Ayamikan", size: 40))
                                .foregroundColor(.gray)
                        }
                        .offset(x: 75, y: 0)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(LinearGradient(gradient: Gradient(colors: [light_blue,.purple]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(width: 200, height: 60)
                        Text("Login in")
                            .font(.custom("Ayamikan", size: 40))
                            .foregroundColor(.white)
                    }
                    .offset(x: -75, y: 0)

                }
                Divider()
                    .frame(width: 320)
                    .padding(5)
                
                HStack{
                    Image(systemName: "envelope")
                        .foregroundColor(Color.purple.opacity(0.5))
                        .font(.title)
                        .background(RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.purple.opacity(0.5), lineWidth: 3)
                                        .frame(width: 45, height: 45)
                        )
                    
                    TextField("Email@mail...", text: $mail)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 47)
                        .background(Color.purple.opacity(0.5))
                }.padding(1)
                
                HStack{
                    Image(systemName: "lock")
                        .foregroundColor(Color.purple.opacity(0.5))
                        .font(.title)
                        .background(RoundedRectangle(cornerRadius: 0)
                                        .stroke(Color.purple.opacity(0.5), lineWidth: 3)
                                        .frame(width: 45, height: 45)
                        )
                    
                    SecureField("Password", text: $password)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 47)
                        .background(Color.purple.opacity(0.5))
                }.padding(1)
                
                Button {
                    authen.login(mail: mail, password: password)
                    player.pause()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                            .frame(width: 150, height: 40)

                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.purple, lineWidth: 5)
                            .frame(width: 150, height: 40)
                        
                        Text("LOG IN")
                            .foregroundColor(Color.white)
                            .font((.custom("Ayamikan", size: 35)))
                            
                    }
                    .padding()
                }.offset(y:30)
            }
        }.offset(x:35)
        .onAppear {
            fileUrl = Bundle.main.url(forResource: song, withExtension: "mp3")!
            let item = AVPlayerItem(url: fileUrl)
            self.looper = AVPlayerLooper(player: player , templateItem: item)
            player.play()
                //player.volume = Float(volume)
        }
    }
    
}

struct SignUpAccountView : View {
    @ObservedObject var authen : Authentication
    @Binding var showLogin: Bool
    @State private var name: String = ""
    @State private var mail: String = ""
    @State private var password: String = ""
    @State var looper: AVPlayerLooper?
    @State private var song = "Menu"
    @State private var volume = 0.8
    @State private var fileUrl = Bundle.main.url(forResource: "Menu", withExtension: "mp3")!
    @State private var player = AVQueuePlayer()
    @EnvironmentObject var MyData : PlayersData
    var body: some View {
        ZStack {
            Image("bg1")
                .resizable()
                .frame(width: 450,height: 450)
                .opacity(0.6)
            VStack{
                ZStack{
                    Button {
                        showLogin = true
                        player.pause()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.blue
                                    .opacity(0.4))
                                .frame(width: 200, height: 60)
                            Text("Login In")
                                .font(.custom("Ayamikan", size: 40))
                                .foregroundColor(.gray)
                        }
                        .offset(x: -75, y: 0)
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(LinearGradient(gradient: Gradient(colors: [light_blue,.purple]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(width: 200, height: 60)
                        Text("Sign Up")
                            .font(.custom("Ayamikan", size: 40))
                            .foregroundColor(.white)
                    }
                    .offset(x: 75, y: 0)
                }
                Divider()
                    .frame(width: 320)
                    .padding(5)
                HStack{
                    Image(systemName: "person")
                        .foregroundColor(Color.purple.opacity(0.5))
                        .font(.title)
                        .background(RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.purple.opacity(0.5), lineWidth: 3)
                                        .frame(width: 45, height: 45)
                        )
                    
                    TextField("Your nickname", text: $name)
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(width: 220, height: 47)
                        .background(Color.purple.opacity(0.5))
                        .offset(x: 3)
                }
                .padding(1)
                
                HStack{
                    Image(systemName: "envelope")
                        .foregroundColor(Color.purple.opacity(0.5))
                        .font(.title)
                        .background(RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.purple.opacity(0.5), lineWidth: 3)
                                        .frame(width: 45, height: 45)
                        )
                    
                    TextField("Email@mail...", text: $mail)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 47)
                        .background(Color.purple.opacity(0.5))
                }
                .padding(1)
                
                HStack{
                    Image(systemName: "lock")
                        .foregroundColor(Color.purple.opacity(0.5))
                        .font(.title)
                        .background(RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.purple.opacity(0.5), lineWidth: 3)
                                        .frame(width: 45, height: 45)
                        )
                    
                    SecureField("Password", text: $password) {
                        // on Submit
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 47)
                    .background(Color.purple.opacity(0.5))
                    .offset(x: 6)
                }
                Button {
                    authen.signUp(name: name, mail: mail, password: password)
                    player.pause()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                            .frame(width: 150, height: 40)

                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.purple, lineWidth: 5)
                            .frame(width: 150, height: 40)
                        
                        Text("Sign Up")
                            .foregroundColor(Color.white)
                            .font((.custom("Ayamikan", size: 35)))
                            
                    }
                    .padding()
                }

            }
        }.offset(x:35)
            .onAppear {
                fileUrl = Bundle.main.url(forResource: song, withExtension: "mp3")!
                let item = AVPlayerItem(url: fileUrl)
                self.looper = AVPlayerLooper(player: player , templateItem: item)
                player.play()
                    //player.volume = Float(volume)
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authen: Authentication())
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(PlayersData())
    }
}
