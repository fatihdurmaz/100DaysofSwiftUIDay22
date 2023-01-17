//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Paul Hudson on 20/10/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var soruSayaci = 1
    @State private var puanGoster = false
    @State private var sonucGoster = false
    @State private var puanBaslik = ""
    @State private var puan = 0

    @State private var ulkeler = tumUlkeler.shuffled()
    @State private var dogruCevap = Int.random(in: 0...2)

    static let tumUlkeler = ["Estonia","Turkey", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(ulkeler[dogruCevap])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            cevapVer(number)
                        } label: {
                            Image(ulkeler[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Puan: \(puan)")
                    .foregroundColor(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }
        .alert(puanBaslik, isPresented: $puanGoster) {
            Button("Devam Et", action: soruSor)
        } message: {
            Text("Puanınız \(puan)")
        }
        .alert("Game over!", isPresented: $sonucGoster) {
            Button("Tekrar", action: yeniOyun)
        } message: {
            Text("Toplam Puanınız: \(puan)")
        }
    }

    func cevapVer(_ number: Int) {
        if number == dogruCevap {
            puanBaslik = "Doğru"
            puan += 1
        } else {
            let needsThe = ["UK", "US"]
            let theirAnswer = ulkeler[number]

            if needsThe.contains(theirAnswer) {
                puanBaslik = "Wrong! That's the flag of the \(theirAnswer)."
            } else {
                puanBaslik = "Wrong! That's the flag of \(theirAnswer)."
            }

            if puan > 0 {
                puan -= 1
            }
        }

        if soruSayaci == 8 {
            sonucGoster = true
        } else {
            puanGoster = true
        }
    }

    func soruSor() {
        ulkeler.remove(at: dogruCevap)
        ulkeler.shuffle()
        dogruCevap = Int.random(in: 0...2)
        soruSayaci += 1
    }

    func yeniOyun() {
        soruSayaci = 0
        puan = 0
        ulkeler = Self.tumUlkeler
        soruSor()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
