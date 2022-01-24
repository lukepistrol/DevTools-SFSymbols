//
//  SFSymbolsView.swift
//  Shared
//
//  Created by Lukas Pistrol on 19.01.22.
//

import LPSwiftUI
import SwiftUI

struct SFSymbolsView: View {
	#if os(iOS)
	@Environment(\.horizontalSizeClass) private var horizantal
	#endif

	@EnvironmentObject private var model: SFSymbolsModel

	@State private var showToolbar: Bool = false

	private var grid: [GridItem] = {
		[.init(.adaptive(minimum: 90), spacing: 30, alignment: .top)]
	}()

	// MARK: - Body
    var body: some View {
        #if os(iOS)
		NavigationView {
			content
		}
		.navigationViewStyle(.stack)
		#else
		content
		#endif
    }

	private var content: some View {
		ScrollView {
			LazyVGrid(columns: grid, alignment: .leading, spacing: 30) {
				ForEach(model.filteredSympols) { symbol in
					SymbolCell(symbol)
				}
			}
			.frame(maxWidth: .infinity)
			.padding()
		}
		.searchable(text: $model.searchText)
		#if os(macOS)
		.background(Color.windowBackground)
		#else
		.background(Color.primaryGroupedBackground)
		#endif
		.safeAreaInset(edge: .bottom) {
			bottomToolbar
		}
		.navigationTitle("SFSymbols")
		.toolbar {
			toolbarContent
		}
	}

	// MARK: - Toolbar
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
					.padding(.vertical)
			}
		}
	}

	// MARK: - Bottom Toolbar
	@ViewBuilder
	private var bottomToolbar: some View {
		if showToolbar {
			VStack(spacing: 16) {
				renderingModePicker
				fontWeightPicker
				ColorPicker("Background Color:", selection: $model.backgroundColor)
				ColorPicker("Symbol Color:", selection: $model.symbolColor)
				// If rendering mode is "hierachial" show two additional colors
				if model.renderingModeSelection == 2 {
					ColorPicker("Symbol Color 2:", selection: $model.symbolSecondaryColor)
						.transition(.move(edge: .bottom).combined(with: .opacity).combined(with: .offset(x: 0, y: 40)))
					ColorPicker("Symbol Color 3:", selection: $model.symbolTertiaryColor)
						.transition(.move(edge: .bottom).combined(with: .opacity).combined(with: .offset(x: 0, y: 20)))
				}
			}
			.font(.system(.headline, design: .rounded))
			.padding(.vertical, 8)
			.lpBottomToolbar()
			.animation(.default, value: model.renderingModeSelection)
			.transition(.move(edge: .bottom).combined(with: .opacity))
		}
	}

	// MARK: Rendering Mode Picker
	private var renderingModePicker: some View {
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
	}

	// MARK: Font Weight Picker
	private var fontWeightPicker: some View {
		HStack {
			Text("Font Weight:")
				.font(.system(.headline, design: .rounded))
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
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SFSymbolsView()
			.environmentObject(SFSymbolsModel())
    }
}



