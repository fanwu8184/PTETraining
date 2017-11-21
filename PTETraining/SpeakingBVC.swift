//
//  SpeakingBVC.swift
//  PTETraining
//
//  Created by Fan Wu on 6/11/17.
//  Copyright © 2017 8184. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

private let animationTime = 0.5
private let intervalT: TimeInterval = 0.1
private let timeoutForWebView: TimeInterval = 3
private let iTForWaveform: TimeInterval = 0.05
private let factorOfWaveform: CGFloat = 20
private let temporaryFileName = "audioFileName.m4a"
private let isTranscribedRecordUDK = "isTranscribedRecord"
private let noFile = "Sorry, there is no audio file to play."
private let redordPermissionReminder = "To record your voice, please go to your privacy setting to enable your Microphone."
private let speechPermissionReminder = "To transcribe your voice, please go to your privacy setting to enable your Speech Recognition."
private let speechRestricted = "Speech recognition restricted on this device."
private let speechNotAvailable = "Sorry, the Speech Recognition is NOT available now."

class SpeakingBVC: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIWebViewDelegate {
    @IBOutlet weak var timeProgressView: UIProgressView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speakingCollectionView: UICollectionView!
    @IBOutlet weak var tcView: UIView!
    @IBOutlet weak var tcTextView: UITextView!
    @IBOutlet weak var tipsView: UIView!
    @IBOutlet weak var tipsWebView: UIWebView!
    @IBOutlet weak var audioTrackerStackView: UIStackView!
    @IBOutlet weak var audioCurrentTimeLabel: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var audioLengthLabel: UILabel!
    @IBOutlet weak var waveformView: SwiftSiriWaveformView!
    @IBOutlet weak var waveformStackView: UIStackView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var heightOfProgressView: NSLayoutConstraint!
    private let waveTimer = FWTimer()
    private let audioTimer = FWTimer()
    private var audioRecorder = FWRecorder()
    private var audioPlayer =  FWPlayer()
    private let speechRecognizer = FWSpeech()
    private var isTranscribedRecord: Bool {
        get { return UserDefaults.standard.object(forKey: isTranscribedRecordUDK) as? Bool ?? false}
        set { UserDefaults.standard.set(newValue, forKey: isTranscribedRecordUDK) }
    }
    var timer = FWTimer()
    var data = [Any]()
    var currentPage: IndexPath?
    var isPlayingPractice = false
    var timeToPrepare: Float { return 5 }
    var timeToRecord: Float { return 10 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.updateUI()
        }
        timing()
        audioRecorder.requestPermission { (allowed) in
            if !allowed { ProgressHud.message(to: self.view, msg: redordPermissionReminder) }
        }
        loadContentForWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAll()
    }
    
    @IBAction func timing() {
        if timer.isRunning {
            stopTimer()
        } else {
            startTimer(timeToPrepare) { self.record() }
        }
    }
    
    @IBAction func record() {
        if audioRecorder.isRecording {
            stopRecorderAndWaveTimer()
            stopTimer()
        } else {
            stopTimer()
            showCollectionView()
            audioRecorder.record(audioFileURL: getCacheFileURL(temporaryFileName)) { (recorder, error) in
                if let err = error {
                    ProgressHud.message(to: self.view, msg: err)
                } else {
                    recorder?.delegate = self
                    self.startTimer(self.timeToRecord) {
                        self.timeLabel?.text = "0"
                        self.stopRecorderAndWaveTimer()
                    }
                    self.showWaveformStackView()
                    self.activateWaveform()
                }
            }
        }
    }
    
    //play recorded file
    @IBAction func play() {
        if audioPlayer.isPlaying {
            stopPlayerAndAudioTimer()
            showButtonStackView()
        } else {
            stopTimer()
            if isFileExists() {
                audioPlayer.play(audioFileURL: getCacheFileURL(temporaryFileName)) { (player, error) in
                    if let err = error {
                        ProgressHud.message(to: self.view, msg: err)
                    } else {
                        player?.delegate = self
                        self.showAudioTrackerStackView()
                        self.updateAudioTrackerView()
                    }
                }
            } else {
                ProgressHud.message(to: self.view, msg: noFile)
            }
        }
    }
    
    @IBAction func tip() {
        stopTimer()
        if tipsView.isHidden {
            showTips()
        } else {
            showCollectionView()
        }
    }
    
    @IBAction func transcribe() {
        stopAll()
        if tcView.isHidden {
            showTranscript()
            play()
            transcribeRecord()
        } else {
            showCollectionView()
            showButtonStackView()
        }
    }
    
    @IBAction func slide(_ sender: UISlider) {
        audioPlayer.currentTime = TimeInterval(Float(audioPlayer.duration) * sender.value)
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    //============REQUIRED OVERRIDE=================
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func updateCellWhenScroll() {
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / speakingCollectionView.frame.width)
        if currentPage?.item != pageNumber {
            updateCellWhenScroll()
            currentPage = IndexPath(item: pageNumber, section: 0)
            stopAll()
            timing()
            showButtonStackView()
        }
    }
    
    //this function also works for iPad
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        speakingCollectionView.collectionViewLayout.invalidateLayout()
        DispatchQueue.main.async {
            //put the code in the main async means so that it will be called after the rotation
            self.scrollToCurrentPage()
        }
    }
    
    // MARK: Timing
    func startTimer(_ seconds: Float, completion: (() -> Void)?) {
        let counterTime = seconds
        timer.activate(seconds: counterTime, intervalTime: intervalT, action: { (leftTime) in
            let progress = (counterTime - leftTime) / counterTime
            self.timeLabel?.text = "\(Int(leftTime))"
            self.timeProgressView?.setProgress(progress, animated: true)
        }) { completion?() }
    }
    
    func stopTimer() {
        timer.stop {
            self.timeLabel?.text = "\(Int(self.timeToPrepare))"
            self.timeProgressView?.setProgress(0, animated: true)
        }
    }
    
    // MARK: Recorder
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        isTranscribedRecord = false
        showButtonStackView()
    }
    
    // MARK: Player
    func playPractice(_ urlString: String) {
        ProgressHud.processing(to: view)
        audioPlayer.play(url: urlString) { (player, error) in
            ProgressHud.hideProcessing(to: self.view)
            if let err = error {
                ProgressHud.message(to: self.view, msg: err)
            } else {
                player?.delegate = self
                self.showAudioTrackerStackView()
                self.updateAudioTrackerView()
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        showButtonStackView()
        audioTimer.stop()
    }
    
    // MARK: Transcript
    private func transcribeRecord() {
        func performTask() {
            if !speechRecognizer.isTaskRunning && !isTranscribedRecord {
                if speechRecognizer.isAvailable {
                    speechRecognizer.transcribe(audioFileURL: getCacheFileURL(temporaryFileName)) { (result, error) in
                        DispatchQueue.main.async {
                            if let err = error {
                                self.tcTextView.text = err
                            } else {
                                self.isTranscribedRecord = true
                                self.tcTextView.text = result
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.tcTextView.text = speechNotAvailable
                    }
                }
            } else if isTranscribedRecord {
                DispatchQueue.main.async {
                    self.tcTextView.text = self.speechRecognizer.finalResult
                }
            }
        }
        
        speechRecognizer.requestPermission { (authStatus) in
            switch authStatus {
            case .authorized:
                performTask()
            case .denied:
                DispatchQueue.main.async {
                    self.tcTextView.text = speechPermissionReminder
                }
            case .restricted:
                DispatchQueue.main.async {
                    self.tcTextView.text = speechRestricted
                }
            default:
                break
            }
        }
    }
    
    // MARK: WebView
    func getWebFileURL(completion: @escaping (URL?, String?) -> Void) {
        print("getWebFileURL need to be overrided")
    }
    
    private func loadContentForWebView() {
        ProgressHud.processing(to: tipsWebView)
        getWebFileURL { (url, error) in
            ProgressHud.hideProcessing(to: self.tipsWebView)
            if let tipsURL = url {
                let req = URLRequest(url: tipsURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeoutForWebView)
                self.tipsWebView.loadRequest(req)
            } else if let err = error {
                self.tipsWebView.loadHTMLString("<br><br><br><h1>\(err)</h1>", baseURL: nil)
            }
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        ProgressHud.processing(to: tipsWebView)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ProgressHud.hideProcessing(to: tipsWebView)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        ProgressHud.hideProcessing(to: tipsWebView)
        ProgressHud.message(to: tipsWebView, msg: error.localizedDescription)
    }
    
    // MARK: Audio Tracker
    private func updateAudioTrackerView() {
        audioTimer.activate(intervalTime: intervalT, action: { (_) in
            let s = String(format: "%02d", (Int(self.audioPlayer.currentTime) % 60))
            let m = String(format: "%02d", (Int(self.audioPlayer.currentTime) / 60))
            self.audioCurrentTimeLabel.text = "\(m):\(s)"
            self.audioSlider.value = Float(self.audioPlayer.currentTime / self.audioPlayer.duration)
        })
        let second = String(format: "%02d", (Int(audioPlayer.duration) % 60))
        let minute = String(format: "%02d", (Int(audioPlayer.duration) / 60))
        audioLengthLabel.text = "\(minute):\(second)"
    }
    
    // MARK: Waveform
    private func activateWaveform() {
        audioRecorder.enableMeters()
        waveTimer.activate(seconds: timeToRecord, intervalTime: iTForWaveform, action: { (_) in
            self.audioRecorder.updateMeters()
            if let averagePower = self.audioRecorder.averagePower(channel: 0) {
                let amplitude = pow(10, CGFloat(averagePower) / factorOfWaveform)
                self.waveformView.amplitude = amplitude * factorOfWaveform
            }
        })
    }
    
    // MARK: File Management
    private func getCachesDirectory() -> URL {
        let pathURLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let docsDirectURL = pathURLs[0]
        return docsDirectURL
    }
    
    private func getCacheFileURL(_ filename: String) -> URL {
        return getCachesDirectory().appendingPathComponent(filename)
    }
    
    private func isFileExists() -> Bool {
        return FileManager.default.fileExists(atPath: getCacheFileURL(temporaryFileName).path)
    }
    
    // MARK: Others
    private func updateUI() {
        timeProgressView?.layer.cornerRadius = heightOfProgressView.constant / 2
        scrollToCurrentPage()
    }
    
    private func scrollToCurrentPage() {
        if let indexPath = currentPage {
            speakingCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    private func stopRecorderAndWaveTimer() {
        audioRecorder.stop()
        waveTimer.stop()
    }
    
    private func stopPlayerAndAudioTimer() {
        isPlayingPractice = false
        audioPlayer.stop()
        audioTimer.stop()
    }
    
    private func stopAll() {
        stopTimer()
        stopRecorderAndWaveTimer()
        stopPlayerAndAudioTimer()
    }
    
    private func showCollectionView() {
        if speakingCollectionView.isHidden {
            UIView.animate(withDuration: animationTime) {
                self.speakingCollectionView.isHidden = false
                self.hideTranscript()
                self.hideTips()
            }
            scrollToCurrentPage()
        }
    }
    
    private func hideCollectionView() {
        if !speakingCollectionView.isHidden {
            self.speakingCollectionView.isHidden = true
        }
    }
    
    private func showTranscript() {
        if tcView.isHidden {
            UIView.animate(withDuration: animationTime) {
                self.tcView.isHidden = false
                self.hideCollectionView()
                self.hideTips()
            }
        }
    }
    
    private func hideTranscript() {
        if !tcView.isHidden {
            self.tcView.isHidden = true
        }
    }
    
    private func showTips() {
        if tipsView.isHidden {
            UIView.animate(withDuration: animationTime) {
                self.tipsView.isHidden = false
                self.hideCollectionView()
                self.hideTranscript()
            }
        }
    }
    
    private func hideTips() {
        if !tipsView.isHidden {
            self.tipsView.isHidden = true
        }
    }
    
    private func showButtonStackView() {
        if buttonStackView.isHidden {
            UIView.animate(withDuration: animationTime) {
                self.buttonStackView.isHidden = false
                self.hideWaveformStackView()
                self.hideAudioTrackerStackView()
            }
        }
    }
    
    private func hideButtonStackView() {
        if !buttonStackView.isHidden {
            self.buttonStackView.isHidden = true
        }
    }
    
    private func showWaveformStackView() {
        if waveformStackView.isHidden {
            UIView.animate(withDuration: animationTime) {
                self.waveformStackView.isHidden = false
                self.hideButtonStackView()
                self.hideAudioTrackerStackView()
            }
        }
    }
    
    private func hideWaveformStackView() {
        if !waveformStackView.isHidden {
            self.waveformStackView.isHidden = true
        }
    }
    
    private func showAudioTrackerStackView() {
        if audioTrackerStackView.isHidden {
            UIView.animate(withDuration: animationTime) {
                self.audioTrackerStackView.isHidden = false
                self.hideButtonStackView()
                self.hideWaveformStackView()
            }
        }
    }
    
    private func hideAudioTrackerStackView() {
        if !audioTrackerStackView.isHidden {
            self.audioTrackerStackView.isHidden = true
        }
    }
}

