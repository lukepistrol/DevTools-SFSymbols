//
//  DevToolsApp.swift
//  Shared
//
//  Created by Lukas Pistrol on 19.01.22.
//

import SwiftUI

@main
struct DevToolsApp: App {
	@StateObject private var model: SFSymbolsModel = .init()

    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(model)
        }
    }
}
