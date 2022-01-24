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

	init() {
        #if canImport(UIKit)
		navigationTitleStyle()
		#endif
	}

    var body: some Scene {
        WindowGroup {
            SFSymbolsView()
				.environmentObject(model)
        }
    }

	#if canImport(UIKit)
	private func navigationTitleStyle() {
		let fontSize: CGFloat = 34
		let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
		let roundedFont: UIFont
		if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
			roundedFont = UIFont(descriptor: descriptor, size: fontSize)
		} else {
			roundedFont = systemFont
		}
		UINavigationBar.appearance().titleTextAttributes = [.font : roundedFont.withSize(17)]
		UINavigationBar.appearance().largeTitleTextAttributes = [.font : roundedFont]
	}
	#endif
}
