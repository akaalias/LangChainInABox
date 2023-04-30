//
//  StandardOutTerminal.swift
//  LangChainInABox
//
//  Created by Alexis Rondeau on 30.04.23.
//

import SwiftUI

struct StandardOutTerminal: View {
    @StateObject var state = ApplicationState.shared
    @EnvironmentObject var embeddedPython: EmbeddedPython

    var body: some View {
        if embeddedPython.running {
            ProgressView()
                .progressViewStyle(.linear)
        } else {
            Text("\(embeddedPython.stdoutOutput.trimmingCharacters(in: .whitespacesAndNewlines))")
                .multilineTextAlignment(.leading)
                .font(.system(size: 18))
                .padding(16)
        }
    }
}

struct StandardOutTerminal_Previews: PreviewProvider {
    static var previews: some View {
        StandardOutTerminal()
    }
}
