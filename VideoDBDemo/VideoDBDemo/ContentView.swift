//
//  ContentView.swift
//  VideoDBDemo
//
//  Created by Avismara Hugoppalu on 05/02/24.
//

import SwiftUI
import VideoDB

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }.backgroundStyle(.blue)
        .onAppear(perform: {
            let connection = Connection(apiKey: "sk-rvfUc6Qgv9HhoGRx-IOaDQexRA-811y3W1OQ94OsQic")

            Task {
                let result = await connection.getVideo(with: "m-295f3280-8966-4c2c-8daf-c39f514e6b7a")
                switch result {
                case .success(let video):

                    print(result)
                case .failure(let error):
                    print(error)
                }

            }

        })
        .padding()
    }
}

