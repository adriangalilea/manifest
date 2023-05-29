import AVFoundation
import Foundation

class AudioRecorder: NSObject, ObservableObject {
    private var audioEngine: AVAudioEngine!
    private var audioFile: AVAudioFile!
    private var audioPlayer: AVAudioPlayer?
    @Published var isRecording = false

    override init() {
        super.init()
        audioEngine = AVAudioEngine()
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
        let inputNode = audioEngine.inputNode
        let bus = 0

        if bus < 0 || bus >= inputNode.numberOfInputs {
            print("Invalid bus: \(bus)")
            return
        }

        let recordingFormat = inputNode.outputFormat(forBus: bus)
        do {
            audioFile = try AVAudioFile(forWriting: audioFilename, settings: recordingFormat.settings)
        } catch {
            print("Could not create audio file: \(error)")
            return
        }

        inputNode.installTap(onBus: bus, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            do {
                try self.audioFile.write(from: buffer)
            } catch {
                print("Could not write to audio file: \(error)")
            }
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
            DispatchQueue.main.async {
                self.isRecording = true
            }
        } catch {
            print("Could not start recording: \(error)")
        }
    }

    func playRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.play()
            print("Playing recorded audio...")
        } catch {
            print("Could not play recorded audio: \(error)")
        }
    }

    func stopRecording() {
        audioEngine.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.audioEngine.inputNode.removeTap(onBus: 0)
            DispatchQueue.main.async {
                self.isRecording = false
                print("Recording stopped")
            }
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
