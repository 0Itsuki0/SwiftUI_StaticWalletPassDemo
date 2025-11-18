//
//  ContentView.swift
//  StaticWalletPassDemo
//
//  Created by Itsuki on 2025/11/18.
//

import SwiftUI
import PassKit

struct ContentView: View {
    @Environment(\.openURL) private var openURL
    
    @State private var pkPass: PKPass? = nil
    @State private var error: String? = nil
    private let passBundleName = "itsuki.giftcard.pass"
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if let pkPass {
                    Text("A Pass From Itsuki!")
                        .font(.title)
                        .fontWeight(.bold)

                    HStack(spacing: 16) {
                        Image(uiImage: pkPass.icon)
                            
                        VStack(alignment: .leading) {
                            Text(pkPass.localizedDescription)
                                .font(.headline)
                            Text("By \(pkPass.organizationName)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                    }

                    AddPassToWalletButton([pkPass], onCompletion: { result in
                        if result, let passURL = pkPass.passURL {
                            openURL(passURL)
                        }
                    })
                    .fixedSize() // otherwise will take any available spaces
                    .addPassToWalletButtonStyle(.blackOutline)

                    
                } else {
                    Group {
                        if let error {
                            Text(error)
                        } else {
                            Text("I don't know what is going on!")
                        }
                    }
                    .foregroundStyle(.red)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.yellow.opacity(0.1))
            .navigationTitle("Simple Wallet Pass")
            .onAppear {
                guard let url = Bundle.main.url(forResource: passBundleName, withExtension: "pkpass") else {
                    self.error = "\(passBundleName).pkpass not found."
                    return
                }
                do {
                    let data = try Data(contentsOf: url)
                    self.pkPass = try PKPass(data: data)
                } catch(let error) {
                    print("error creating PKPass: ", error)
                    self.error = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
