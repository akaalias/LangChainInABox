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
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(embeddedPython.stdoutOutput.trimmingCharacters(in: .whitespacesAndNewlines))")
                            .multilineTextAlignment(.leading)
                            .lineSpacing(12)
                            .font(.system(size: 16))
                            .padding(16)
                        
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct StandardOutTerminal_Previews: PreviewProvider {
    static var previews: some View {
        StandardOutTerminal()
    }
}
