//
//  ContentView.swift
//  AppleMusicLyricsPlayer
//
//  Created by Magesh Sridhar on 2/5/23.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State var audioPlayer: AVAudioPlayer!
    @State var progress: CGFloat = 0.0
    @State private var playing: Bool = false
    @State var duration: Double = 0.0
    @State var formattedDuration: String = ""
    @State var formattedProgress: String = "00:00"
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image("Cover")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
                    .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 5)
                VStack(alignment: .leading) {
                    Text("Dreaming (feat. Danyka Nadeau)")
                        .foregroundStyle(.primary)
                        .bold()
                        .font(.subheadline)
                    Text("Virtual Riot")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                Spacer()
                Image(systemName: "ellipsis.circle.fill")
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                
            }.padding(.horizontal).padding(.horizontal).padding(.top, 70)
            LyricView(formattedProgress: $formattedProgress, songProgress: $progress).padding(.top, 30)
            GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle().frame(width: geometry.size.width , height: 6)
                                .foregroundStyle(.secondary)
                                .opacity(0.3)
                            
                            Rectangle().frame(width: min(progress*geometry.size.width, geometry.size.width), height: 6)
                                .foregroundStyle(.primary)
                        }.cornerRadius(45.0)
            }.frame(height: 6)
            .padding(.horizontal)
            .padding(.horizontal)
            HStack {
                Text(formattedProgress)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
                Spacer()
                Text(formattedDuration)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
            
            HStack(alignment: .center, spacing: 20) {
                Spacer()
                Image(systemName: "backward.fill")
                    .font(.largeTitle)
                    .imageScale(.small)
                Spacer()
                Button(action: {
                    if audioPlayer.isPlaying {
                        playing = false
                        self.audioPlayer.pause()
                    } else if !audioPlayer.isPlaying {
                        playing = true
                        self.audioPlayer.play()
                    }
                }) {
                    Image(systemName: playing ?
                          "pause.fill" : "play.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height:40)
                    .foregroundColor(.white)
                    
                }
                Spacer()
                Image(systemName: "forward.fill")
                    .font(.largeTitle)
                    .imageScale(.small)
                Spacer()
            }.frame(maxWidth: 100)
            
            Text("Developed by Magesh Sridhar using SwiftUI 💜")
                .font(.caption)
                .bold()
                .padding()
                .padding(.vertical, 10)
        }
        .frame(maxHeight: .infinity)
        .background(Image("BG")
            .resizable()
            .scaledToFill()
            .blur(radius: 80))
        .ignoresSafeArea()
        .onAppear {
            initialiseAudioPlayer()
        }
    }
    
    func initialiseAudioPlayer() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]
        
        let path = Bundle.main.path(forResource: "Dreaming", ofType: "mp3")!
        self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        self.audioPlayer.prepareToPlay()
        formattedDuration = formatter.string(from: TimeInterval(self.audioPlayer.duration))!
        duration = self.audioPlayer.duration
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if !audioPlayer.isPlaying {
                playing = false
            }
            progress = CGFloat(audioPlayer.currentTime / audioPlayer.duration)
            formattedProgress = formatter.string(from: TimeInterval(self.audioPlayer.currentTime))!
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

var lyricsList: [String] = [
    "",
    "Freedom of mind, I'm faster than the speed of sound",
    "Let's dim the lights and shift into new paradise",
    "Little child, living wild",
    "Where do you go when you sleep at night?",
    "Can you reach the sky or walk on fire?",
    "Where do you go when you're dreaming",
    "Dreaming?",
    "When you're dreaming",
    "Where do you go when you're dreaming",
    "Dreaming?",
    "When you're dreaming",
    "Tell me where do you go",
    "Brwrabum",
    "Bubipiwrabum",
    "Brrwraabum Tana tun tun",
    "Brwrabum",
    "Bubipiwrabum",
    "Papapapa",
    "Wrrrrooomm",
    "Brwrabum",
    "Bubipiwrabum",
    "Brrwraabum Tun tun tun",
    "Brwrabum",
    "Bubipiwrabum",
    "Bwan bwan bwan wraaw",
    "Brwyuhum",
    "Bubipiyuhum",
    "Brrrwyuhum Tun tun tun",
    "Brwyuhm",
    "Bubipiyuhm",
    "Papapapa",
    "Vrrmmmmmmm",
    "Brwyuhum Bubipiyuhum",
    "Brwyuhum Bubipiyuhum",
    "Brrrwyuhum Tun tun tun",
    "Brwyuhum Bubipiyuhum",
    "Tell me where do you go",
    "Tell me where–",
    "Tell me",
    "Tell me where do you go",
    "Tell me where–",
    "Tell me",
    "Written by: Christian Valentin Brunn, Danyka Nadeau",
]

let timestamps : [String:Int] = ["00:00": 0, "00:07":1, "00:14":2, "00:18":3, "00:21":4, "00:25":5, "00:30":6, "00:33":7, "00:38":8, "00:44":9, "00:46": 10, "00:53": 11, "00:54": 12, "00:55": 13, "00:56": 14, "00:57":15, "00:58":16, "00:59":17, "01:00": 18, "01:01":19, "01:02":20, "01:03":21, "01:04":22, "01:05":23, "01:06": 24, "01:08":25, "01:09":26, "01:10":27, "01:11":28, "01:12": 29, "01:13" : 30, "01:14":31, "01:15" : 32, "01:16":33, "01:17":34, "01:19":35, "01:20":36, "01:27":37, "01:28":38, "01:34":39, "01:41":40, "01:42": 41, "01:43" : 42]
let numberOfLines : [Int] = [1, 3, 2, 1, 2, 2, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2]
let animationLength : [Double] = [0, 7, 7, 6, 3, 4, 5, 3, 5, 6, 3, 7, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 1, 1, 3]
var textWidths : [CGFloat] = []

struct LyricView: View {
    @Binding var formattedProgress: String
    @Binding var songProgress: CGFloat
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(0...lyricsList.count - 1, id: \.self) { i in
                LyricLine(i: i, formattedProgress: $formattedProgress, songProgress: $songProgress)
                
            }
        }.padding()
            .padding()
            .offset(y: 1040)
            .frame(height: 450)
            .mask {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .clear, location: .zero),
                        Gradient.Stop(color: .black, location: 0.01),
                        Gradient.Stop(color: .black, location: 0.65),
                        Gradient.Stop(color: .clear, location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
    }
}

struct LyricLine: View {
    @State var lineNumber: Int = 0
    var i: Int
    @State var phase: CGFloat = 0
    @State var textWidth : CGFloat = 0
    @State var startShakeEffect = false
    @Binding var formattedProgress : String
    @Binding var songProgress : CGFloat
    @State var offset : CGFloat = 0
    var body: some View {
        Text(lyricsList[i])
            .font(getFontType(i: i))
            .padding(.vertical, lyricsList[i].count == 5 ? 20 : 0)
            .bold()
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
            .modifier(i == lineNumber ? AnimatedMask(phase: phase, textWidth: textWidth, lineNumber: lineNumber) : AnimatedMask(textWidth: 0, lineNumber: i))
            .blur(radius: i == lineNumber ? 0 : 4)
            .glow(color: i == lineNumber && (lineNumber == 7 || lineNumber == 10) ? .purple : .clear, radius: phase * 8)
            .modifier(startShakeEffect ? ShakeEffect(shakeNumber: 16) : ShakeEffect(shakeNumber: 0))
            .background(GeometryReader { g in
                if i == lineNumber {
                    Color.clear.onAppear {
                        textWidth = g.size.width
                        if lineNumber == 18  || lineNumber == 31 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.linear(duration: animationLength[lineNumber])) {
                                    startShakeEffect = true
                                }
                            }
                        } else {
                            startShakeEffect = false
                        }
                    }
                }
            })
            .offset(y: offset)
            .onChange(of: formattedProgress) { newValue in
                if let scrollToLine = timestamps[newValue] {
                    withAnimation(.spring()) {
                        lineNumber = scrollToLine + 1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(i-lineNumber)) {
                        withAnimation(.spring()) {
                            offset = offset - (33.6 * CGFloat(numberOfLines[scrollToLine])) - 20
                        }
                    }
                    phase = 0
                    withAnimation(.easeInOut(duration: animationLength[lineNumber])) {
                        phase = 1
                    }
                }
            }
            .onChange(of: songProgress) { newValue in
                if newValue > 0 && newValue < 0.0003 {
                    if let scrollToLine = timestamps["00:00"] {
                        withAnimation(.spring()) {
                            lineNumber = scrollToLine + 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(i-lineNumber)) {
                            withAnimation(.spring()) {
                                offset = offset - 15
                            }
                        }
                        phase = 0
                        withAnimation(.easeInOut(duration: animationLength[lineNumber])) {
                            phase = 1
                        }
                    }
                }
            }
    }
}

func getFontType(i: Int) -> Font {
    return i < lyricsList.count - 1 ? .title : .subheadline
}

struct OverlayView: View {
    let width: CGFloat
    let progress: CGFloat
    let lineNumber: Int
    var body: some View {
        Path() { path in
            for i in 0...numberOfLines[lineNumber] {
                let yValue : CGFloat = (18 * CGFloat(i+1)) + (20 * CGFloat(i))
                path.move(to: CGPoint(x: 0, y: yValue))
                path.addLine(to: CGPoint(x: width, y: yValue))
            }
        }.trim(from: 0, to: progress)
            .stroke(lineWidth: 38)
    }
}



struct AnimatedMask: AnimatableModifier {
    var phase: CGFloat = 0
    var textWidth: CGFloat
    var lineNumber: Int
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(OverlayView(width: textWidth, progress: phase, lineNumber: lineNumber))
            .mask(MaskTextView(lineNumber: lineNumber))
    }
}

extension View {
    func glow(color: Color = .red, radius: CGFloat = 20) -> some View {
        self
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
}

struct MaskTextView : View {
    var lineNumber: Int
    var body: some View {
        Text(lyricsList[lineNumber])
            .font(getFontType(i: lineNumber))
            .padding(.vertical, lyricsList[lineNumber].count == 5 ? 20 : 0)
            .bold()
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct ShakeEffect: AnimatableModifier {
    var shakeNumber: CGFloat = 0
    
    var animatableData: CGFloat {
        get {
            shakeNumber
        } set {
            shakeNumber = newValue
        }
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: sin(shakeNumber * .pi * 2) * 5)
    }
}

