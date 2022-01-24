//
//  SFSymbolsModel.swift
//  DevTools
//
//  Created by Lukas Pistrol on 19.01.22.
//

import Foundation
import LPSwiftUI
import SwiftUI

class SFSymbolsModel: ObservableObject {

	@Published private (set) var symbols: [SFSymbol] = []
	@Published var symbolColor: Color = .accentColor
	@Published var symbolSecondaryColor: Color = .indigo
	@Published var symbolTertiaryColor: Color = .primary
	@Published var renderingModeSelection: Int = 0
	@Published var searchText: String = ""
	@Published var selectedWeight: Font.Weight = .regular

    #if os(macOS)
	@Published var backgroundColor: Color = .windowBackground
	#else
	@Published var backgroundColor: Color = .primaryBackground
	#endif

	public var filteredSympols: [SFSymbol] {
		if searchText.isEmpty {
			return symbols
		}
		return self.symbols.filter { $0.name.contains(searchText.lowercased()) }
	}

	init() {
		fetchSymbols()
	}

	public var renderingMode: SymbolRenderingMode {
		switch renderingModeSelection {
		case 0: return .multicolor
		case 1: return .hierarchical
		case 2: return .palette
		case 3: return .monochrome
		default: return .multicolor
		}
	}

	private func fetchSymbols() {
		let path = Bundle.main.path(forResource: "sfsymbols", ofType: "txt") // file path for file "data.txt"
		do {
			let string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
			let array = string.components(separatedBy: .newlines)
			self.symbols = array.map(SFSymbol.init)
		} catch {
			print(error.localizedDescription)
		}
	}
}

extension SFSymbolsModel {
	struct SFSymbol: Identifiable, Comparable {
		var id: String { self.name }
		var name: String

		static func < (lhs: SFSymbolsModel.SFSymbol, rhs: SFSymbolsModel.SFSymbol) -> Bool {
			lhs.name < rhs.name
		}
	}
}
