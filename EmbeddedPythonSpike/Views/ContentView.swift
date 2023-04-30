//
//  ContentView.swift
//  EmbeddedPythonSpike
//
//  Created by Alexis Rondeau on 20.04.23.
//

import SwiftUI
import PythonKit
import CodeEditor

struct ContentView: View {
    
    @StateObject var state = ApplicationState.shared
    @EnvironmentObject var embeddedPython: EmbeddedPython
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                StandardOutTerminal()
                Spacer()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top) {
            PythonEditor()
                .frame(maxHeight: 300)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            self.isAutomaticQuoteSubstitutionEnabled = false
            self.backgroundColor = .clear
            self.drawsBackground = false
        }
    }
}
