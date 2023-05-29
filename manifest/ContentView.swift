import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var audioRecorder = AudioRecorder()
    @StateObject private var photoSearcher = PhotoSearcher()
    @State private var transcription: String?  // The transcription

    var body: some View {
        VStack {
            if let transcription = transcription {
                Text(transcription)
                    .font(.headline)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    .animation(.default, value: transcription)
            } else {
                Text("Press the Record button or 'S' key to start recording")
                    .font(.caption)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    .animation(.default, value: transcription)
            }

            Button(action: {
                if self.audioRecorder.isRecording {
                    self.audioRecorder.stopRecording()
                    OpenAIWhisper().translate(fileURL: audioRecorder.getDocumentsDirectory().appendingPathComponent("recording.wav")) { result in
                        switch result {
                        case .success(let trans):
                            self.transcription = trans
                            print("Transcription: \(trans)")
                            self.photoSearcher.searchAndLoadPhoto(query: trans) { isLoaded in
                                DispatchQueue.main.async {
                                    self.photoSearcher.isImageLoaded = isLoaded
                                    // if the image is loaded successfully, set isImageLoaded to false after 2 seconds
                                    if isLoaded {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            self.photoSearcher.isImageLoaded = false
                                        }
                                    }
                                }
                            }

                        case .failure(let error):
                            print("Transcription failed with error: \(error)")
                        }
                    }
                } else {
                    self.audioRecorder.startRecording()
                }
            }) {
                Image(systemName: audioRecorder.isRecording ? "stop.fill" : "record.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                    .foregroundColor(audioRecorder.isRecording ? .red : .red)
            }
            .buttonStyle(PlainButtonStyle()) // This removes the default button styling
            
            if photoSearcher.isImageLoaded {
                Text("✅")
                    .font(.largeTitle)
                    .transition(.slide)
                    .animation(.default, value: photoSearcher.isImageLoaded)
            }
        }
        .padding()
        .cornerRadius(15)
        .background(Color.black.opacity(0.5))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
