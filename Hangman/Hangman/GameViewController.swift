//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var phraseDisplay: UILabel!
    
    @IBOutlet weak var hangmanImage: UIImageView!
    
    @IBOutlet weak var guessField: MaxLengthTextField!
    
    @IBOutlet weak var incorrectLabel: UILabel!
    
    var phrase = ""
    var discovered = Set<String>()
    var incorrect = Set<String>()
    var incorrectCount = 0
    var winSet = Set<String>()
    var gameOver = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        displayPhraseInitial(sentence: phrase)
        setImage(name: "hangman1.gif")
        buildWinCheck()
    
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildWinCheck() {
        for i in phrase.characters {
            winSet.insert(String(i))
        }
        winSet.remove(" ")
    }
    
    func checkWinState() {
        if winSet.count == 0 {
            gameOver = true
            alertWin()
        }
        
        
    }
    
    func displayPhraseInitial(sentence: String) {
        var set = ""
        for i in sentence.characters {
            if String(i) == " " {
                set = set + "   "
            } else {
                set = set + "_ "
            }
            
        }
        
        phraseDisplay.text = set
    }
    
    func checkGuess(sentence: String, guess: String) {
        if !gameOver {
            var set = ""
            var isIn = false
            for i in sentence.characters {
                if String(i) == " " {
                    set = set + "   "
                } else if String(i) == guess {
                    isIn = true
                    set = set + String(i)
                    winSet.remove(String(i))
                    discovered.insert(String(i))
                    checkWinState()
                } else {
                    if discovered.contains(String(i)) {
                        set = set + String(i)
                    } else {
                        set = set + "_ "
                    }
                    
                }
            }
            
            if isIn == false {
                incorrect.insert(String(guess))
                badGuess(guess: guess)
            }
            
            phraseDisplay.text = set
        }
        
    }
    
    func badGuess(guess: String) {
        incorrectCount += 1
        if incorrectCount > 6 {
            gameOver = true
            alertFail()
            } else {
            let name = "hangman" + String(incorrectCount+1) + ".gif"
            setImage(name: name)
        }
        
        
    }
    
    func alertFail() {
        let alertController = UIAlertController(title: "Sorry", message:"You Lost. Try Restarting?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)

    }
    
    func alertWin() {
        let alertController = UIAlertController(title: "Congratulations", message:"You Won! Play Again?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setImage(name : String) {
        hangmanImage.image = UIImage(named: name)!
    }
    
    func displayIncorrect() {
        var display = ""
        for i in incorrect {
            display = display + " " + i
        }
        incorrectLabel.text = display
    }
    
    
    @IBAction func guess(_ sender: Any) {
        let guess = guessField.text
        checkGuess(sentence: phrase, guess: guess!)
        displayIncorrect()
        
        
    }
    
    @IBAction func restartGame(_ sender: Any) {
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        displayPhraseInitial(sentence: phrase)
        setImage(name: "hangman1.gif")
        winSet = Set<String>()
        incorrectCount = 0
        gameOver = false
        discovered = Set<String>()
        incorrect = Set<String>()
        buildWinCheck()
        incorrectLabel.text = "No Incorrect"
        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
