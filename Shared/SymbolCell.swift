//
//  SymbolCell.swift
//  DevTools
//
//  Created by Lukas Pistrol on 24.01.22.
//

import SwiftUI

struct SymbolCell: View {

	@EnvironmentObject private var model: SFSymbolsModel

	private var symbol: SFSymbolsModel.SFSymbol

	public init(_ symbol: SFSymbolsModel.SFSymbol) {
		self.symbol = symbol
	}

	var body: some View {
		VStack {
			image
			#if os(iOS)
				.contentShape(ContentShapeKinds.contextMenuPreview,
							  RoundedRectangle(cornerRadius: 10))
			#endif
				.contextMenu { copyButtons }
			Text(symbol.name)
				.font(.system(.callout, design: .rounded))
				.lineLimit(2)
				.truncationMode(.tail)
		}
	}

	@ViewBuilder
	private var copyButtons: some View {
		Button {
			#if os(macOS)
			NSPasteboard.general.setString(symbol.name, forType: .string)
			#else
			UIPasteboard.general.string = symbol.name
			#endif
		} label: {
			Label("Copy Name", systemImage: "doc.on.doc.fill")
		}
		Button {
            #if os(macOS)
			NSPasteboard.general.setString("Image(systemName: \"\(symbol.name)\")", forType: .string)
            #else
			UIPasteboard.general.string = "Image(systemName: \"\(symbol.name)\")"
			#endif
		} label: {
			Label("Copy SwiftUI Image", systemImage: "chevron.left.forwardslash.chevron.right")
		}
	}

	private var image: some View {
		Image(systemName: symbol.name)
			.resizable()
			.font(.system(size: 10, weight: model.selectedWeight, design: .default))
			.aspectRatio(contentMode: .fit)
			.frame(height: 50)
			.frame(maxWidth: .infinity)
			.foregroundStyle(model.symbolColor, model.symbolSecondaryColor, model.symbolTertiaryColor)
			.padding(20)
			.background {
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.foregroundColor(model.backgroundColor)
					RoundedRectangle(cornerRadius: 10)
						.stroke(lineWidth: 1)
						.foregroundColor(.separator)
				}
			}
			.symbolRenderingMode(model.renderingMode)
	}
}

struct SymbolCell_Previews: PreviewProvider {
    static var previews: some View {
		SymbolCell(.init(name: "circle.fill"))
    }
}
