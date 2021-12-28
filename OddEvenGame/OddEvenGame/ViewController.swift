//
//  ViewController.swift
//  OddEvenGame
//
//  Created by bb on 2021/12/20.
//


/*
 logic foundation
 - game start button press -> alert -> user input number -> butten press -> result screen
 1. computer selects random number from 1 to 10
 2. user chooses one of odd and even betting the number of marbles he or she has.
 3. screen show the result.
 */
/*
 music addition
 1. add music file
 2. add AVFoundation framework
 3. make AVAudioPlayer object and and play music
 */

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var computerBallCountLbl: UILabel!
    @IBOutlet weak var userBallCountLbl: UILabel!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var firstImage: UIImageView!
    
    
    var player: AVAudioPlayer?
    var comBallCount: Int = 20
    var userBallCount: Int = 20
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        computerBallCountLbl.text = String(comBallCount)
        userBallCountLbl.text = String(userBallCount)
        self.imageContainer.isHidden = true
        
        self.play(fileName: "Instrument Strum")
    }

    // 음악파일이름 입력하면 해당 음악파일을 찾아 실행시키는 함수
    func play(fileName: String){
        let filePath = Bundle.main.url(forResource: fileName, withExtension: "mp3")
        
        // 예외처리 및 에러처리
        guard let path = filePath else {
            return
        }
//        self.player = try? AVAudioPlayer(contentsOf: path)
        do {
            self.player = try AVAudioPlayer(contentsOf: path)
            
            guard let soundPlayer = self.player else {
                return
            }
            
            soundPlayer.prepareToPlay()
            soundPlayer.play()
            
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
    }
    
    @IBAction func gameStartPressed(_ sender: Any) {

        print("game start!")
        print(self.getRandom())
        
        self.showAlert()
        self.play(fileName: "Fart Toot")
        
    }
    
    func showAlert() {
        
        // 경고창
        let alert = UIAlertController(title: "GAME START", message: "please choose odd or even", preferredStyle: .alert)
        
        // 버튼과 동작
//        let okayBtn = UIAlertAction.init(title: "확인", style: .default) {_ in
//            print("확인버튼을 클릭했습니다.")
//        }
//
//        alert.addAction(okayBtn)
        
        let oddBtn = UIAlertAction.init(title: "홀", style: .default) {_ in
            print("홀버튼을 클릭했습니다.")
         
            // 입력한 홀짝 값을 불러오고 guard let구문을 활용해서 옵셔널 값을 가져오기
            guard let input = alert.textFields?.first?.text, let value = Int(input) else {
                return
            }
            
            print("입력한 값은 \(input)입니다.")
            
            self.imageShow()
            self.getWinner(count: value, select: "홀")

        }
        
        let evenBtn = UIAlertAction.init(title: "짝", style: .default) {_ in
            print("짝버튼을 클릭했습니다.")
            
            guard let input = alert.textFields?.first?.text else {
                return
            }
            guard let value = Int(input) else {
                return
            }
            
            
            print("입력한 값은 \(input)입니다.")
            
            self.imageShow()
            self.getWinner(count: value, select: "짝")
        }
        
        // 입력창 추가
        // placeholder: 사용자가 입력하기 전에는 떠있고, 입력하고 나서는 사라지게 됨.
        alert.addTextField { textField in
            textField.placeholder = "Enter the number of beads to bet on"
        }
        
        alert.addAction(oddBtn)
        alert.addAction(evenBtn)
        
        self.present(alert, animated: true) {
            print("화면이 띄워졌습니다.")
        }
    }
    
    
    // 구슬의 갯수가 0이 되었는지 판단하는 함수
    func checkAccountEmpty(balls: Int) -> Bool {
        return balls == 0
    }
    
    // 사용자가 이겼는지 컴퓨터가 이겼는지 판단하는 함수
    func getWinner(count: Int, select: String){
        
        let com = self.getRandom()
        let comType = com % 2 == 0 ? "짝" : "홀"
        
        var result = comType
        if comType == select {
            print("User win")
            result = result + "(User win)"
            self.resultLbl.text = result
            self.calculateBalls(winner: "user", count: count)
        } else {
            print("Computer win")
            result = result + "(Computer win)"
            self.resultLbl.text = result
            self.calculateBalls(winner: "com", count: count)
        }
        

    }
    
    func getRandom() -> Int {
        return Int(arc4random_uniform(10) + 1)
    }
    
    // getWinner 결과에 따라서 사용자와 컴퓨터의 구슬을 계산해주는 함수
    func calculateBalls(winner: String, count: Int){
        if winner == "com" {
            self.userBallCount = self.userBallCount - count
            self.comBallCount = self.comBallCount + count
            if self.checkAccountEmpty(balls: self.comBallCount){
                self.resultLbl.text = "finally computer win"
                self.play(fileName: "Instrument Strum")
            }
        } else {
            self.userBallCount = self.userBallCount + count
            self.comBallCount = self.comBallCount - count
            if self.checkAccountEmpty(balls: self.userBallCount){
                self.resultLbl.text = "finally user win"
                self.play(fileName: "Instrument Strum")
            }
        }
        
        self.userBallCountLbl.text = "\(self.userBallCount)"
        self.computerBallCountLbl.text = "\(self.comBallCount)"
    }
    
    
    // 홀짝 버튼 클릭 후 결과 보여주기 전에 이미지쇼추가
    func imageShow() {
        
        self.play(fileName: "Wood Plank Flicks")
        
        self.imageContainer.isHidden = false
        UIView.animate(withDuration: 2.0) {
            
            self.firstImage.transform = CGAffineTransform(scaleX: 5, y: 5)
            self.firstImage.transform = CGAffineTransform(scaleX: 1, y: 1)
      
        } completion: { _ in
            
            self.imageContainer.isHidden = true
            
        }

    }
}


