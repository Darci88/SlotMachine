//
//  ContentView.swift
//  SlotMachine
//
//  Created by user219285 on 4/2/23.
//

import SwiftUI

struct ContentView: View {
    let symbols = [imageBell, imageCherry, imageCoin, imageGrape, imageSeven, imageStrawberry]
    let haptics = UINotificationFeedbackGenerator()
    
    @State private var showingInfoView: Bool = false
    @State private var reels: Array = [0, 1, 2]
    @State private var highscore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var isActiveBet10: Bool = true
    @State private var isActiveBet20: Bool = false
    @State private var showingModal: Bool = false
    @State private var animatingSymbol: Bool = false
    @State private var animatingModal: Bool = false
    
    //MARK: - FUNCTIONS
    //Spin the reels
    func spinReels(){
//        reels[0] = Int.random(in: 0...symobols.count - 1)
//        reels[1] = Int.random(in: 0...symobols.count - 1)
//        reels[2] = Int.random(in: 0...symobols.count - 1)
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        playSound(sound: soundSpin, type: soundTypeMp3)
        haptics.notificationOccurred(.success)
    }
    
    //Check the winnings
    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] {
            //Player wins
            playerWins()
            
            //New highscore
            if coins > highscore {
                newHighScore()
            } else {
                playSound(sound: soundWin, type: soundTypeMp3)
            }
        } else {
            //Player loses
            playerLoses()
        }
    }
    
    func playerWins() {
        coins += betAmount * 10
    }
    
    func newHighScore() {
        highscore = coins
        UserDefaults.standard.set(highscore, forKey: "HighScore")
        playSound(sound: soundHighScore, type: soundTypeMp3)
    }
    
    func playerLoses() {
        coins -= betAmount
    }
    
    func activateBet20() {
        betAmount = 20
        isActiveBet20 = true
        isActiveBet10 = false
        playSound(sound: soundCasinoChips, type: soundTypeMp3)
        haptics.notificationOccurred(.success)
    }
    
    func activateBet10() {
        betAmount = 10
        isActiveBet10 = true
        isActiveBet20 = false
        playSound(sound: soundCasinoChips, type: soundTypeMp3)
        haptics.notificationOccurred(.success)
    }
    
    //Game is over
    func isGameOver() {
        if coins <= 0 {
            //Show modal window
            showingModal = true
            playSound(sound: soundGameOver, type: soundTypeMp3)
        }
    }
    
    func resetGame() {
        UserDefaults.standard.set(0, forKey: "HighScore")
        highscore = 0
        coins = 100
        activateBet10()
        playSound(sound: soundChimeup, type: soundTypeMp3)
    }
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            //MARK: - Background
            LinearGradient(gradient: Gradient(colors: [colorPink, colorPurple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            //MARK: - Interface
            VStack(alignment: .center, spacing: 5) {
                //MARK: - Header
                LogoView()
                Spacer()
                
                //MARK: - Score
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("\(highscore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    }
                    .modifier(ScoreContainerModifier())
                }
                
                //MARK: - SlotMachine
                VStack(alignment: .center, spacing: 0) {
                    //REEL #1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)), value: animatingSymbol)
                            .onAppear {
                                animatingSymbol.toggle()
                                playSound(sound: soundRiseup, type: soundTypeMp3)
                            }
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        //REEL #2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)), value: animatingSymbol)
                                .onAppear {
                                    animatingSymbol.toggle()
                                }
                        }
                        
                        Spacer()
                        
                        //REEL #3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)), value: animatingSymbol)
                                .onAppear {
                                    animatingSymbol.toggle()
                                }
                        }
                    }
                    .frame(maxWidth: 500)
                    
                    //MARK: - Spin Button
                    Button(action: {
                        //1. set the default state: no animtion
                        withAnimation {
                            animatingSymbol = false
                        }
                        
                        //2. spin the reels with changing the symbols
                        spinReels()
                        
                        //3. trigger the animation after changing the symbols
                        withAnimation {
                            animatingSymbol = true
                        }
                        
                        //4. Check winning
                        checkWinning()
                        //5. Game is over
                        isGameOver()
                    }) {
                        Image(imageSpin)
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    }
                }
                .layoutPriority(2)
                
                //MARK: - Footer
                Spacer()
                
                HStack {
                    //MARK: - Bet 20
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            activateBet20()
                        }) {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet20 ? colorYellow : .white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        Image(imageCasinoChips)
                            .resizable()
                            .offset(x: isActiveBet20 ? 0 : 20)
                            .opacity(isActiveBet20 ? 1 : 0)
                            .modifier(casinoChipsModifier())
                    }
                    
                    Spacer()
                    
                    //MARK: - Bet 10
                    HStack(alignment: .center, spacing: 10) {
                        Image(imageCasinoChips)
                            .resizable()
                            .offset(x: isActiveBet10 ? 0 : -20)
                            .opacity(isActiveBet10 ? 1 : 0)
                            .modifier(casinoChipsModifier())
                        
                        Button(action: {
                            activateBet10()
                        }) {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? colorYellow : .white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                    }
                }
            }
                //MARK: - Buttons reset/info
            .overlay (
                //Reset
                Button(action: {
                   resetGame()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            .overlay (
                //Info
                Button(action: {
                    showingInfoView = true
                }) {
                    Image(systemName: "info.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
            
            //MARK: - POPUP
            if $showingModal.wrappedValue {
                ZStack {
                    colorTransparentBlack.edgesIgnoringSafeArea(.all)
                    
                    //Modal
                    VStack(spacing: 0) {
                        //Title
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded, weight: .heavy))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(colorPink)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        //Message
                        VStack(alignment: .center, spacing: 16) {
                            Image(imageSevenReel)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 75)
                            
                            Text("Bad luck! You lost all of the coins.\nLet's play again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                showingModal = false
                                animatingModal = false
                                activateBet10()
                                coins = 100
                            }) {
                                Text("New game".uppercased())
                                    .font(.system(.body, design: .rounded, weight: .semibold))
                                    .accentColor(colorPink)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                    Capsule()
                                        .strokeBorder(lineWidth: 1.75)
                                        .foregroundColor(colorPink)
                                    )
                            }
                        }
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: colorTransparentBlack, radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                    .animation(.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: showingModal)
                    .onAppear {
                        animatingModal = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
