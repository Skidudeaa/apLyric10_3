//
//  ContentView.swift
//  apLyric10_3
//
//  Created by Thomas Amosson on 2023.10.03.
//
/*
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
*/

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


