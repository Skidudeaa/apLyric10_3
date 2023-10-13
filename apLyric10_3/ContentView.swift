//
//  ContentView.swift
//  apLyric10_3
//
//  Created by Thomas Amosson on 2023.10.03.
//



/*
//-----------------------------------


import SwiftUI
import Foundation
//import SwiftyJSON



struct Lyric {
  let timestamp: Double
  let text: String
}


// LyricsManager

class LyricsManager {

  let lyrics: [Lyric]

  init() {
    let lyricsJSON = loadJSON("lyrics.json")
    let parsedLyrics = parseLyrics(lyricsJSON)
    self.lyrics = parsedLyrics
  }

  func parseLyrics(json: [String:Any]) -> [Lyric] {
    return json["lyrics"].map { lyricJSON in
      return Lyric(
        timestamp: lyricJSON["time"] as! Double,
        text: lyricJSON["text"] as! String
      )
    }
  }

}

// LyricsView

struct LyricsView: View {

  @StateObject var lyricsManager = LyricsManager()
  
  @State var currentLyric: Lyric
  @State var playbackTime: Double = 0

  var body: some View {

    VStack {
    
      Text("Song Title")
        .font(.title)
        
      ScrollView {
      
        ForEach(lyricsManager.lyrics) { lyric in
        
          LyricView(lyric: lyric)
            .id(lyric.id)
          
        }
        
      }
      .onChange(of: playbackTime) {
        currentLyric = lyricsManager.lyrics.first(where: {
          $0.timestamp < playbackTime
        })

      }
      
    }
    
    .onReceive(Timer.publish(every: 0.1, on: .main)) { _ in
          currentTimestamp = Date().timeIntervalSinceReferenceDate
        }

  }

}


// LyricView

struct LyricView: View {

  let lyric: Lyric
  
  var body: some View {
  
      Text(lyric.text)
        .transition(.slide)
        .animation(.easeInOut, value: playbackTime)
        .font(.body)
        .padding()
    
  }

}



struct LyricLine: View {

  // State properties to drive animations
  @State private var lineNumber: Int
  @State private var phase: CGFloat
  @State private var textWidth: CGFloat
  @State private var startShakeEffect: Bool
  
  // Bindings to parent view for data flow
  @Binding private var formattedProgress: String
  @Binding private var songProgress: CGFloat
  
  // Additional state
  @State private var offset: CGFloat = 0

  var body: some View {

    // Display lyric text
    Text(lyricsList[i])

      // Styling
      .font(.custom("Font", size: 16))
      .padding(20)
      .bold()
      .foregroundColor(.secondary)

      // Layout
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .fixedSize(horizontal: false, vertical: true)
      
      // Animated mask
      .mask(
        lineNumber == i ?
           AnimatedMask(phase: phase, width: textWidth, line: lineNumber)
         :
           AnimatedMask(width: 0, line: i)
      )
      
      // Effects
      .blur(radius: lineNumber == i ? 0 : 4)
      .luminanceToAlpha(
        threshold: phase,
        intensity: 8,
        color: lineNumber == 7 || lineNumber == 10 ? .purple : .clear
      )
      
      // Shake animation
      .modifier(
        startShakeEffect ?
           ShakeEffect(count: 16)
         :
           ShakeEffect(count: 0)
      )

  }

}

*/

import SwiftUI
import Foundation




// Model for Lyric
struct Lyric: Codable, Identifiable, Equatable {
    var id: UUID? = UUID()
    let timestamp: Double
    let lyric: String

    enum CodingKeys: String, CodingKey {
        case timestamp, lyric
    }
}

struct LyricsContainer: Codable {
    let lyrics: [Lyric]
}


class LyricsManager: ObservableObject {
    @Published var lyrics: [Lyric] = []
    private let queue = DispatchQueue(label: "LyricsManagerQueue")

    func loadLyrics() {
        if let url = Bundle.main.url(forResource: "lyrics", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(LyricsContainer.self, from: data)
                self.lyrics = jsonData.lyrics
            } catch {
                print("Error while parsing file: \(error)")
            }
        }
    }


    func currentLyric(forPlaybackTime playbackTime: Double) -> Lyric? {
        return queue.sync {
            return lyrics.last(where: { $0.timestamp <= playbackTime })
        }
    }
}

struct LyricsView: View {
    @StateObject var lyricsManager = LyricsManager()

    @State var currentLyric: Lyric?
    @State var startTime: Date? = nil
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("Song Title")
                .font(.title)
            
            let currentIndex = lyricsManager.lyrics.firstIndex(where: { $0.id == currentLyric?.id }) ?? 0
            
            ForEach(max(0, currentIndex - 1)...min(currentIndex + 1, lyricsManager.lyrics.count - 1), id: \.self) { index in
                LyricView(lyric: lyricsManager.lyrics[index], isCurrent: index == currentIndex)
                    .blur(radius: index == currentIndex ? 0 : 2)
                    .rotation3DEffect(
                        .degrees(Double(index - currentIndex) * 90),
                        axis: (x: 1.0, y: 0.0, z: 0.0)
                    )
            }
            
            Button("Start") {
                startTime = Date()
            }
        }
        .onAppear {
            lyricsManager.loadLyrics()
        }
        .onReceive(timer) { _ in
            guard let startTime = startTime else { return }
            
            let playbackTime = Date().timeIntervalSince(startTime)
            currentLyric = lyricsManager.currentLyric(forPlaybackTime: playbackTime)
        }
    }
}

struct LyricView(lyric: lyricsManager.lyrics[index], isCurrent: index == currentIndex)
    .blur(radius: index == currentIndex ? 0 : 2)
    .rotation3DEffect(
        .degrees(max(-90, min(90, Double(index - currentIndex) * 90))),
        axis: (x: 1.0, y: 0.0, z: 0.0)
    )
    let lyric: Lyric
    let isCurrent: Bool

    @State var phase: CGFloat = 0
    @State var textWidth : CGFloat = 0
    @State var startShakeEffect = false

    var body: some View {
        Text(lyric.lyric)
            .font(.body)
            .padding()
            .background(isCurrent ? Color.yellow : Color.clear)
            .modifier(isCurrent ? AnimatedMask(phase: phase, textWidth: textWidth, lineNumber: lyric.id.hashValue, text: lyric.lyric) : AnimatedMask(phase: 0, textWidth: 0, lineNumber: lyric.id.hashValue, text: lyric.lyric))
            .blur(radius: isCurrent ? 0 : 4)
            .shadow(color: isCurrent ? .purple : .clear, radius: phase * 8)
            .modifier(startShakeEffect ? ShakeEffect(shakeNumber: 2) : ShakeEffect(shakeNumber: 2))
            .background(GeometryReader { g in
                if isCurrent {
                    Color.clear.onAppear {
                        textWidth = g.size.width
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.linear(duration: Double(lyric.lyric.count) / 10.0)) {
                                startShakeEffect = true
                            }
                        }
                    }
                }
            })
            .onChange(of: isCurrent) { newValue in
                if newValue {
                    phase = 0
                    withAnimation(.easeInOut(duration: Double(lyric.lyric.count) / 10.0)) {
                        phase = 1
                    }
                }
            }
    }




struct OverlayView: View {
    let width: CGFloat
    let progress: CGFloat
    let lineNumber: Int
    let text: String

    var body: some View {
        let characterWidth: CGFloat = 30 // width of a character in your font
        let viewWidth: CGFloat = 40// width of your view
        let numberOfCharacters = text.count
        let numberOfLines = Int(ceil(CGFloat(numberOfCharacters) * characterWidth / viewWidth))

        return Path() { path in
            for i in 0..<numberOfLines {
                let yValue : CGFloat = (18 * CGFloat(i+1)) + (20 * CGFloat(i))
                path.move(to: CGPoint(x: 0, y: yValue))
                path.addLine(to: CGPoint(x: width, y: yValue))
            }
        }.trim(from: 0, to: progress)
            .stroke(lineWidth: 38)
    }
}





struct MaskTextView : View {
    var text: String

    var body: some View {
        Text(text)
            .font(.body) // replace this with the font you want to use
            .padding(.vertical, text.count == 5 ? 20 : 0)
            .bold()
            .fixedSize(horizontal: false, vertical: true)
    }
}



struct AnimatedMask: AnimatableModifier {
    var phase: CGFloat = 0
    var textWidth: CGFloat
    var lineNumber: Int
    var text: String  

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func body(content: Content) -> some View {
        content
            .overlay(OverlayView(width: textWidth, progress: phase, lineNumber: lineNumber, text: text))
            .mask(MaskTextView(text: text))
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


@main
struct apLyric10_3App: App {
    var body: some Scene {
        WindowGroup {
            LyricsView()
        }
    }
}


