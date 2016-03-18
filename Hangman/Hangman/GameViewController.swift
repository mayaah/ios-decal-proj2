//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var startOver: UIButton!

    var word = String()
    var incorrect = [Character]()
    var originalWord = String()
    var gameOver: Bool = false
    
    

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var trollMan: UIImageView!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        let hangmanPhrases = HangmanPhrases()
        var phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
        
        var hangmanWord = ""
        self.word = ""
        self.incorrect = [Character]()
        for i in phrase.characters.indices {
            if phrase[i] == " " {
                hangmanWord = hangmanWord + "   "
                self.word = self.word + "   "
            } else {
                hangmanWord = hangmanWord + "_ "
                self.word = self.word + String(phrase[i]) + " "
            }
        }
        originalWord = hangmanWord
        wordLabel?.text = hangmanWord
        

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickletter(sender: UIButton) {
        guessAction(sender)
    }
    
    func guessAction(button:UIButton) {
        if (!gameOver) {
            button.setTitleColor(UIColor.grayColor(), forState: .Normal)
            let guessedLetter = button.titleLabel!.text
            let hangmanWord = wordLabel.text!
            var correct: Bool = false
            
            let guess: Character = guessedLetter!.characters[guessedLetter!.characters.startIndex]
            
            var newWord = ""
            for i in self.word.characters.indices {
                if self.word.characters[i] == guess {
                    correct = true
                    newWord = newWord + String(guess)
                } else {
                    newWord = newWord + String(hangmanWord.characters[i])
                }
            }
            wordLabel.text = newWord
            
            if (correct) {
                if (wordLabel.text! == self.word) {
                    gameWon()
                }
            } else {
                incorrectAction(button)
            }
        }
    }
    
    func gameWon() {
        gameOver = true
        let alertController = UIAlertController(title:"hohoho", message: "You win", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title:"Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func incorrectAction(button: UIButton) {
        var incorrectLabelText = incorrectGuessesLabel.text!
        let guessedLetter = button.titleLabel!.text
        let guess: Character = guessedLetter!.characters[guessedLetter!.characters.startIndex]
        if !self.incorrect.contains(guess) {
            incorrectLabelText = incorrectLabelText + " " + String(guess)
            self.incorrect.append(guess)
        }
        
        let dying = "tfd" + String(6 - incorrect.count + 1) + ".png"
        trollMan.image = UIImage(named: dying)
        incorrectGuessesLabel.text = incorrectLabelText
        
        if (incorrect.count+1 >= 7) {
            gameLost()
        }
    }
    
    func gameLost() {
        gameOver = true
        let alertController = UIAlertController(title: "trolololol", message: "YOU LOSE", preferredStyle: .Alert)
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func startingOver(sender: AnyObject) {
        gameOver = false
        trollMan.image = UIImage(named: "tfd0.png")
        self.incorrect = [Character]()
        wordLabel.text = originalWord
        incorrectGuessesLabel.text = "Incorrect Guesses:"
        for view in self.view.subviews as [UIView] {
            if let keyboard = view as? UIStackView {
                for row in keyboard.subviews as [UIView] {
                    for col in row.subviews as [UIView] {
                        if let btn = col as? UIButton {
                            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
                        }
                    }
                }
            }
        }
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
