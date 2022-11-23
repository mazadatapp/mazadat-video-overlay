//
//  VideoPlayerController.swift
//  MazadatVideoOverlay
//
//  Created by Karim Saad on 22/11/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerController: UIViewController,PlayerPlaybackDelegate, PlayerDelegate{
   
    var PlayerContainer : UIView!
    var slider:UISlider!
    var videoDuration=0.0;
    var player : Player!
    var PlayerOverLay:UIView!
    var Play:UIButton!
    var Pause:UIButton!
    var Forward:UIButton!
    var Backward:UIButton!
    var FullScreen:UIButton!
    var ExitFullScreen:UIButton!
    
    var StartPosition:CGPoint!
    var startPos=0
    var canMove=false
    var offsetY=0.0
    var offsetHeight=0.0
    private var videoURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque=false
        view.backgroundColor = .clear
        
        PlayerContainer = UIView(frame: CGRect(x: 0, y: 40, width: view.frame.width, height: 300))
        PlayerContainer.backgroundColor = .black
        view.addSubview(PlayerContainer)
        
    
        player = Player()
        //player.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        
        self.addChild(player)
        PlayerContainer.addSubview(player.view)
        player.didMove(toParent: self)
        
        player.url = URL(string: videoURL)
        player.playFromBeginning()
        
        addConstraints(currentView: player.view, MainView: PlayerContainer, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0, bottom: true, bottomValue: 0, leading: true, leadingValue: 0, trailing: true, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        
        PlayerOverLay=UIView()
        PlayerOverLay.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        PlayerContainer.addSubview(PlayerOverLay)
        addConstraints(currentView: PlayerOverLay, MainView: PlayerContainer, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: 0, leading: true, leadingValue: 0, trailing: true, trailingValue: 0, width: false, widthValue: 0, height: true, heightValue: 80)
        

        slider=UISlider(frame: CGRect(x: 20, y: 0, width: PlayerOverLay.frame.width - 40, height: 40))
        slider.setThumbImage(UIImage(named: "Thumb"), for: .normal)
        PlayerOverLay.addSubview(slider)
        addConstraints(currentView: slider, MainView: PlayerOverLay, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0, bottom: false, bottomValue: 0, leading: true, leadingValue: 20, trailing: true, trailingValue: -20, width: false, widthValue: 0, height: true, heightValue: 40)

        Play=UIButton()
        Play.setImage(UIImage(named: "Play"), for: .normal)
        PlayerOverLay.addSubview(Play)
        addConstraints(currentView: Play, MainView: PlayerOverLay, centerX: true, centerXValue: 0, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: -10, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: true, widthValue: 30, height: true, heightValue: 30)

        Pause=UIButton()
        Pause.setImage(UIImage(named: "Pause"), for: .normal)
        PlayerOverLay.addSubview(Pause)
        Pause.isHidden=true
        addConstraints(currentView: Pause, MainView: PlayerOverLay, centerX: true, centerXValue: 0, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: -10, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: true, widthValue: 30, height: true, heightValue: 30)

        Forward=UIButton()
        Forward.setImage(UIImage(named: "Forward"), for: .normal)
        PlayerOverLay.addSubview(Forward)
        addConstraints(currentView: Forward, MainView: PlayerOverLay, centerX: true, centerXValue: 60, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: -10, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: true, widthValue: 30, height: true, heightValue: 30)

        Backward=UIButton()
        Backward.setImage(UIImage(named: "Backward"), for: .normal)
        PlayerOverLay.addSubview(Backward)
        addConstraints(currentView: Backward, MainView: PlayerOverLay, centerX: true, centerXValue: -60, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: -10, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: true, widthValue: 30, height: true, heightValue: 30)

        FullScreen=UIButton()
        FullScreen.setImage(UIImage(named: "FullScreen"), for: .normal)
        PlayerOverLay.addSubview(FullScreen)
        addConstraints(currentView: FullScreen, MainView: PlayerOverLay, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: -10, leading: false, leadingValue: 0, trailing: true, trailingValue: -10, width: true, widthValue: 30, height: true, heightValue: 30)

        ExitFullScreen=UIButton(frame: CGRect(x: PlayerOverLay.frame.width - 40, y: PlayerOverLay.frame.height-40, width: 30, height: 30))
        ExitFullScreen.setImage(UIImage(named: "Minimize"), for: .normal)
        PlayerOverLay.addSubview(ExitFullScreen)
        ExitFullScreen.isHidden = true
        addConstraints(currentView: ExitFullScreen, MainView: PlayerOverLay, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: -10, leading: false, leadingValue: 0, trailing: true, trailingValue: -10, width: true, widthValue: 30, height: true, heightValue: 30)

        slider.addTarget(self, action: #selector(sliderValueDidChange(sender:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderStartEditing(sender:)), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderEndEditing(sender:)), for: .touchUpInside)


        Play.addTarget(self, action: #selector(pauseVideo(sender:)), for: .touchUpInside)
        Pause.addTarget(self, action: #selector(playVideo(sender:)), for: .touchUpInside)
        Forward.addTarget(self, action: #selector(forwardPressed(sender:)), for: .touchUpInside)
        Backward.addTarget(self, action: #selector(backwardPressed(sender:)), for: .touchUpInside)
        FullScreen.addTarget(self, action: #selector(fullScreenPressed(sender:)), for: .touchUpInside)
        ExitFullScreen.addTarget(self, action: #selector(exitFullScreenPressed(sender:)), for: .touchUpInside)

        //seekTo(time: 200.0)
        // Do any additional setup after loading the view.
    }
    
    func setLink(link:String){
        videoURL = link
    }
    
    func addConstraints(currentView:UIView,MainView:UIView,centerX:Bool,centerXValue:CGFloat,
                        centerY:Bool,centerYValue:CGFloat,top:Bool,topValue:CGFloat,
                        bottom:Bool,bottomValue:CGFloat,leading:Bool,leadingValue:CGFloat,
                        trailing:Bool,trailingValue:CGFloat,width:Bool,widthValue:CGFloat,height:Bool,heightValue:CGFloat){
        
        
        currentView.translatesAutoresizingMaskIntoConstraints = false
        if(top){
            let topConst = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: MainView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: topValue)
            MainView.addConstraint(topConst)
        }
        if(bottom){
            let bottomConst = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: MainView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: bottomValue)
            MainView.addConstraint(bottomConst)
        }
        if(trailing){
            let trailingConst = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: MainView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: trailingValue)
            MainView.addConstraint(trailingConst)
        }
        if(leading){
            let leadingConst = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: MainView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: leadingValue)
            MainView.addConstraint(leadingConst)
        }
        if(centerX){
            let centerXConst = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: MainView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: centerXValue)
            MainView.addConstraint(centerXConst)
        }
        if(centerY){
            let centerYConst = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: MainView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: centerYValue)
            MainView.addConstraint(centerYConst)
        }
        if(width){
            let widthConstraint = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: widthValue)
                
            MainView.addConstraint(widthConstraint)
        }
        if(height){
            let heightConstraint = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: heightValue)
            MainView.addConstraint(heightConstraint)
        }
    }
    
    
    func seekTo(time:Float){
        let myTime = CMTime(seconds: Double(time), preferredTimescale: 60000)
        player.seek(to: myTime)
    }
    func seekBy(time:Double){
        let value = player.currentTime.seconds + time
        let myTime = CMTime(seconds: value, preferredTimescale: 60000)
        player.seek(to: myTime)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        StartPosition=touches.first?.location(in: self.view)
        if(PlayerContainer.frame.contains((touches.first?.location(in: self.view))!)){
            startPos = Int(PlayerContainer.frame.origin.y)
            offsetY = StartPosition.y - PlayerContainer.frame.minY
            offsetHeight = PlayerContainer.frame.maxY - StartPosition.y
            canMove=true;
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let Point=touches.first?.location(in: self.view)
        let newY=CGFloat(startPos) + Point!.y - StartPosition.y
       
        if(Point!.y - offsetY > 40 && Point!.y + offsetHeight < view.frame.height - 40.0){
            PlayerContainer.frame = CGRect(x: 0, y: newY, width: view.frame.width, height: 300)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let Point=touches.first?.location(in: self.view)
        if(Point == StartPosition){
            togglePlayerOverLay()
        }
        if(Point == StartPosition && !canMove){
            dismiss(animated: true)
        }
         
        canMove=false
    }
    func togglePlayerOverLay(){
        PlayerOverLay.isHidden = !PlayerOverLay.isHidden
    }

    func playerReady(_ player: Player) {
        PlayerOverLay.isHidden=true
        videoDuration=(player.playerLayer()?.player?.currentItem?.duration.seconds)!
        slider.maximumValue=Float(videoDuration)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.PlayerContainer.transform = CGAffineTransformMakeRotation(90 * M_PI/180);
//            self.PlayerContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//        }
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
       // print("video buffer time "+String(bufferTime))
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        
    }
    
    func playerCurrentTimeDidChange(_ player: Player) {
        let currenTime=player.currentTime.seconds
        slider.value=Float(currenTime)
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        print("video will start beginner")
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
    
    @objc func sliderValueDidChange(sender: UISlider) {
        
        print("yesssss")
    }
    
    @objc func sliderStartEditing(sender: UISlider) {
        Pause.isHidden=false
        Play.isHidden=true
        player.pause()
        
    }
    
    @objc func sliderEndEditing(sender: UISlider) {
        seekTo(time: sender.value)
        player.playerLayer()?.player?.play()
        
        Pause.isHidden=true
        Play.isHidden=false
        
    }
    
    @objc func pauseVideo(sender: UIButton) {
        player.pause()
        Pause.isHidden=false
        Play.isHidden=true
    }
    
    @objc func playVideo(sender: UIButton) {
        player.playerLayer()?.player?.play()
        Pause.isHidden=true
        Play.isHidden=false
    }
    
    @objc func forwardPressed(sender: UIButton) {
        seekBy(time: 10.0)
    }
    
    @objc func backwardPressed(sender: UIButton) {
        seekBy(time: -10.0)
    }
    
    @objc func fullScreenPressed(sender: UIButton) {
        print(PlayerContainer.frame)
        PlayerContainer.transform = CGAffineTransformMakeRotation(90 * M_PI/180);
        PlayerContainer.frame = CGRect(x: 0, y: 40, width: view.frame.width, height: view.frame.height-80)
        FullScreen.isHidden = true
        ExitFullScreen.isHidden = false
    }
    @objc func exitFullScreenPressed(sender: UIButton) {
        PlayerContainer.transform = CGAffineTransformMakeRotation(0 * M_PI/180);
        PlayerContainer.frame = CGRect(x: 0, y: 40, width: view.frame.width, height: 300)
        FullScreen.isHidden = false
        ExitFullScreen.isHidden = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
