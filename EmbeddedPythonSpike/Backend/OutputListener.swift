// All credit goes to: https://phatbl.at/2019/01/08/intercepting-stdout-in-swift.html
//
//  OutputListener.swift
//  LangChainInABox
//
//

import Foundation
import Cocoa

class OutputListener {
    /// consumes the messages on STDOUT
    let inputPipe = Pipe()
    
    /// outputs messages back to STDOUT
    let outputPipe = Pipe()
    
    /// Buffers strings written to stdout
    var contents = ""
    
    init() {
        // Set up a read handler which fires when data is written to our inputPipe
        inputPipe.fileHandleForReading.readabilityHandler = { [weak self] fileHandle in
            guard let strongSelf = self else { return }
            
            let data = fileHandle.availableData
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                strongSelf.contents += string
                // strongSelf.contents = string
            }
            
            // Write input back to stdout
            strongSelf.outputPipe.fileHandleForWriting.write(data)
            
        }
    }
    
    /// Sets up the "tee" of piped output, intercepting stdout then passing it through.
    func openConsolePipe() {
        // Copy STDOUT file descriptor to outputPipe for writing strings back to STDOUT
        dup2(STDOUT_FILENO, outputPipe.fileHandleForWriting.fileDescriptor)
        
        // Intercept STDOUT with inputPipe
        dup2(inputPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
    }
    
    /// Tears down the "tee" of piped output.
    func closeConsolePipe() {
        // Restore stdout
        freopen("/dev/stdout", "a", stdout)
        
        [inputPipe.fileHandleForReading, outputPipe.fileHandleForWriting].forEach { file in
            file.closeFile()
        }
    }
}
