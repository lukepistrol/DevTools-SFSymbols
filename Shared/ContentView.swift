//
//  ContentView.swift
//  Shared
//
//  Created by Lukas Pistrol on 19.01.22.
//

import LPSwiftUI
import SwiftUI

struct ContentView: View {
	@Environment(\.horizontalSizeClass) private var horizantal

	@EnvironmentObject private var model: SFSymbolsModel

	@State private var showToolbar: Bool = false

    var body: some View {
		NavigationView {
			ScrollView {
				let grid: [GridItem] = [.init(.adaptive(minimum: 90), spacing: 30, alignment: .top)]
				LazyVGrid(columns: grid, alignment: .leading, spacing: 30) {
					ForEach(model.filteredSympols) { symbol in
						symbolCell(symbol)
					}
				}
				.frame(maxWidth: .infinity)
				.padding()
			}
			.searchable(text: $model.searchText)
			.background(Color.primaryGroupedBackground)
			.safeAreaInset(edge: .bottom) {
				if showToolbar {
					bottomToolbar
				}
			}
			.navigationTitle("SFSymbols")
			.toolbar {
				toolbarContent
			}
		}
		.navigationViewStyle(.stack)
    }

	@ToolbarContentBuilder
	private var toolbarContent: some ToolbarContent {
		ToolbarItem(placement: .primaryAction) {
			Button {
				withAnimation(.spring(response: 0.35, dampingFraction: 0.5, blendDuration: 1)) {
					showToolbar.toggle()
				}
			} label: {
				Label("Options", systemImage: "circle.hexagongrid.fill")
					.labelStyle(.iconOnly)
					.imageScale(.large)
					.font(.title3)
					.symbolVariant(showToolbar ? .fill : .none)
					.symbolRenderingMode(showToolbar ? .monochrome : .multicolor)
					.padding(.leading)
					.padding(.vertical)
			}
		}
	}

	private var bottomToolbar: some View {
		VStack(spacing: 16) {
			Picker(selection: $model.renderingModeSelection) {
				Text("Multicolor")
					.tag(0)
				Text("Hierachial")
					.tag(1)
				Text("Palette")
					.tag(2)
				Text("Mono")
					.tag(3)
			} label: {
				Text("Rendering Mode")
			}
			.pickerStyle(.segmented)
			HStack {
				Text("Font Weight:")
					.font(.headline)
				Spacer()
				Picker(selection: $model.selectedWeight) {
					Text("Ultra Light")
						.tag(Font.Weight.ultraLight)
					Text("Thin")
						.tag(Font.Weight.thin)
					Text("Light")
						.tag(Font.Weight.light)
					Text("Regular")
						.tag(Font.Weight.regular)
					Text("Medium")
						.tag(Font.Weight.medium)
					Text("Semi Bold")
						.tag(Font.Weight.semibold)
					Text("Bold")
						.tag(Font.Weight.bold)
					Text("Heavy")
						.tag(Font.Weight.heavy)
					Text("Black")
						.tag(Font.Weight.black)
				} label: {
					Text("Font Weight")
				}
				.font(.headline)
				.pickerStyle(.menu)
			}
			ColorPicker("Background Color:", selection: $model.backgroundColor)
			ColorPicker("Symbol Color:", selection: $model.symbolColor)
			if model.renderingModeSelection == 2 {
				ColorPicker("Symbol Color 2:", selection: $model.symbolSecondaryColor)
					.transition(.move(edge: .bottom).combined(with: .opacity).combined(with: .offset(x: 0, y: 40)))
				ColorPicker("Symbol Color 3:", selection: $model.symbolTertiaryColor)
					.transition(.move(edge: .bottom).combined(with: .opacity).combined(with: .offset(x: 0, y: 20)))
			}
		}
		.font(.headline)
		.padding(.vertical, 8)
		.lpBottomToolbar()
		.animation(.default, value: model.renderingModeSelection)
		.transition(.move(edge: .bottom).combined(with: .opacity))
	}

	private func symbolCell(_ symbol: SFSymbolsModel.SFSymbol) -> some View {
		VStack {
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
				.contentShape(ContentShapeKinds.contextMenuPreview,
							  RoundedRectangle(cornerRadius: 10))
				.contextMenu {
					Button {
						UIPasteboard.general.string = symbol.name
					} label: {
						Label("Copy Name", systemImage: "doc.on.doc.fill")
					}
					Button {
						UIPasteboard.general.string = "Image(systemName: \"\(symbol.name)\")"
					} label: {
						Label("Copy SwiftUI Image", systemImage: "chevron.left.forwardslash.chevron.right")
					}
				}
			Text(symbol.name)
				.font(.callout)
				.lineLimit(2)
				.truncationMode(.tail)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			.environmentObject(SFSymbolsModel())
    }
}
