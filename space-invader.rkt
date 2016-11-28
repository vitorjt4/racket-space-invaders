;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname space-invader) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;>Total: 85/91

;;>Overall, your design is very detail-oriented and easy to follow.

;;>-1 Must have at least 4 rows of invaders per requirement

;;>-1 You have some magical values such as 1, 'left, ect. floating around.
;;>Might want to clean them up.
;; TODO: Fixing magic values


(require 2htdp/image)
(require 2htdp/universe)

(define UNIT 10)
(define ROW-NUM-INVADER 4)
(define COL-NUM-INVADER 9)
(define BULLET-RADIUS 3)
(define BULLET-RED (circle BULLET-RADIUS 'solid "red"))
(define BULLET-BLK (circle BULLET-RADIUS 'solid "black"))
(define BULLET-MAX-INVADER 10)
(define BULLET-MAX-SPACESHIP 3)
(define INVADER-LENGTH 25)
(define INVADER-RECT (rectangle INVADER-LENGTH INVADER-LENGTH 'solid "red"))
(define GAP-BETWEEN-ROWS 10)
(define CANVAS-WIDTH (* 2 COL-NUM-INVADER INVADER-LENGTH))
(define CANVAS-HEIGHT 600)
(define BACKGROUND (empty-scene CANVAS-WIDTH CANVAS-HEIGHT))
(define SPACESHIP-L 30)
(define SPACESHIP-W 20)
(define SPACESHIP-RECT (rectangle SPACESHIP-L SPACESHIP-W 'solid "black"))
(define SPACESHIP-DIR-INIT 'left)
(define MAX-LIVES 3)
(define MIN-SCORE 0)
(define UNIT-SCORE 5)
(define TICK-ZERO 0)


;; A Direction is one of
;; - 'left
;; - 'right
;; INTERP: represents the direction of either left or right of the spaceship

;; Deconstructor Template
;; direction-fn: Direction -> ???
#;(define (direction-fn direction)
    (cond
      [(symbol=? direction 'left) ...]
      [(symbol=? direction 'right) ...]))


;;;; Data Definition
(define-struct spaceship [position direction lives])

;; Constructor Template:
;; A Spaceship is a (make-spaceship Posn Direction Natural)
;; INTERP: represents a spaceship on the canvas

;; Examples
(define SPACESHIP-INIT (make-spaceship 
                       (make-posn (/ CANVAS-WIDTH 2) (- CANVAS-HEIGHT 20))
                       SPACESHIP-DIR-INIT
                       MAX-LIVES))
(define SPACESHIP-DEAD (make-spaceship 
                       (make-posn (/ CANVAS-WIDTH 2) (- CANVAS-HEIGHT 20))
                       SPACESHIP-DIR-INIT
                       0))

;; Deconstructor Template:
;; spaceship-fn: Spaceship -> ???
#; (define (spaceship-fn spaceship)
     ... (posn-fn (spaceship-position spaceship)) ...
     ... (spaceship-direction spaceship) ... 
     ... (spaceship-lives spaceship) ... )

;;;; Data Definitions:
;; An Invader is a Posn
;; INTERP: represents an invader on the canvas

;; An Bullet is a Posn
;; INTERP: represents a bullet on the canvas

;; An SBullet is a Bullet
;; INTERP: represents a spaceship bullet on the canvas

;; An IBullet is a Bullet
;; INTERP: represents an invader bullet on the canvas

;; A ListOfPosns (LoP) is one of
;; - empty
;; - (cons Posn LoP)
;; INTERP: represents a list of posns

;;;; Examples:
(define LOP-MT empty)
(define LOIP1 (cons (make-posn 1 1) LOP-MT))

;; Deconstructor Template:
;; lop-fn: LoP -> ???
#; (define (lop-fn lop)
     (cond
       [(empty? lop) ...]
       [(cons? lop) ... (posn-fn (first lop)) ... 
                    ... (lop-fn (rest lop) )...]))


;; A ListOfInvaders (LoI) is a LoF<Invader>
;; INTERP: represents a list of invaders on the canvas

;;;; Examples:
(define LOI-MT empty)
(define LOI1 (cons (make-posn 1 1) LOI-MT))

;; Deconstructor Template:
;; loi-fn: LoI -> ???
#; (define (loi-fn loi)
     (cond
       [(empty? loi) ...]
       [(cons? loi) ... (posn-fn (first loi)) ... 
                    ... (loi-fn (rest loi) )...]))

;; A ListOfBullets (LoB) is a LoF<Posn>
;; INTERP: represents a list of bullets on the canvas

;;;; Examples:
(define LOB-MT empty)
(define LOB1 (cons (make-posn 1 1) LOB-MT))

;; Deconstructor Template:
;; lob-fn: LoB -> ???
#; (define (lob-fn lob)
     (cond
       [(empty? lob) ...]
       [(cons? lob) ... (posn-fn (first lob)) ... 
                    ... (lob-fn (rest lob) )...]))

;; An SBullets (LoSB) is a LoF<SBullet>
;; represents a list of bullets from the spaceship

;; An IBullets (LoIB) is a LoF<IBullet>
;; represents a list of bullets from invaders

;; A Score is a Natural
;; represents a list of bullets from invaders
(define-struct world [invaders spaceship sbullets ibullets score ticks])

;; Constructor Template:
;; A World is a (make-world LoF<Invader> Spaceship LoF<SBullet> LoF<IBullet> Natural Natural)
;; INTERP: invaders represents invaders in the game
;;         spaceship represents a spaceship in the game
;;         sbullets represents bullets from the spaceship in the game
;;         ibullets represents bullets from invaders in the game
;;         score represents the score of the current game
;;         ticks represents the ticks of the clock

;; Examples
(define WORLD-0
  (make-world LOI1 SPACESHIP-INIT LOB1 LOB1 MIN-SCORE TICK-ZERO))
;; Deconstructor Template:
;; world-fn: World -> ???
#; (define (world-fn world)
     ... (loi-fn (world-invaders world)) ...
     ... (spaceship-fn (world-spaceship world)) ...
     ... (lob-fn (world-sbullets world)) ...
     ... (lob-fn (world-sbullets world)) ... )




;;;;;;;
;; CONSTANTS defined for test

(define POSN-50-100 (make-posn 50 100))
(define POSN-50-200 (make-posn 50 200))
(define POSN-50-300 (make-posn 50 300))
(define POSN-50-40  (make-posn 50 40))

(define POSN-250-50 (make-posn 250 50))
(define POSN-250-80 (make-posn 250 80))

(define POSN-250-65 (make-posn 250 65))
(define POSN-250-66 (make-posn 250 66))
(define POSN-265-65 (make-posn 265 65))
(define POSN-266-65 (make-posn 266 65))
(define POSN-1 (make-posn 100 100))
(define POSN-2 (make-posn 200 200))
(define POSN-3 (make-posn 300 300))
(define POSN-4 (make-posn 400 400))
(define POSN-5 (make-posn 450 450))

(define LoPSN-1
  (list POSN-50-100 POSN-50-200))
(define LoPSN-2
  (list POSN-50-100 POSN-50-200 POSN-50-300))
(define INVADERS-1 (list POSN-50-40 POSN-250-50))
(define BULLET-250-65 POSN-250-65)
(define BULLET-250-66 POSN-250-66)
(define BULLET-265-65 POSN-265-65)
(define BULLET-266-65 POSN-266-65)
(define SPACESHIP-300-10-left (make-spaceship (make-posn 300 10) 'left MAX-LIVES))
(define WORLD-TEST 
  (make-world (list POSN-50-100) SPACESHIP-300-10-left 
              (list POSN-50-40) (list POSN-250-50) MIN-SCORE TICK-ZERO))


;;;; Signature
;; first-x: Natural -> Real

;;;; Purpose
;; GIVEN: a natural number representing the number of columns
;; RETURNS: the appropriate x coordinate value for the first invader in a row

(define (first-x cols)
  (/ (- CANVAS-WIDTH (* (- cols 1) 2 INVADER-LENGTH)) 2))

;;;; Tests
(check-expect (first-x 9) 25)

;;;; Signature
;; invader-cons-col: Real Real Natural -> LoF<Invader>

;;;; Purpose
;; GIVEN: an x and a y coordinate value and 
;;        a natural number representing the number of columns
;; RETURNS: a list of invaders assigned with appropriate posns

(define (invader-cons-col x y cols)
  (cond
    [(= cols 0)	empty]
    [else (cons 
           (make-posn x y) 
           (invader-cons-col 
            (+ x (* 2 INVADER-LENGTH)) y (- cols 1)))]))

;;;; Tests
(check-expect (invader-cons-col 10 10 2) (list (make-posn 10 10)
                                               (make-posn 60 10)))


;;;; Signature
;; invader-cons-row: Real Natural Natural-> LoF<Invader>

;;;; Purpose
;; GIVEN: a y coordinate value, number of rows and number of columns
;; RETURNS: a list of invaders assigned with appropriate posns

(define (invader-cons-row y rows cols)
  (cond
    [(= rows 0) empty]
    [else (append 
           (invader-cons-col 
            (first-x cols) y cols) 
           (invader-cons-row 
            (+ y INVADER-LENGTH GAP-BETWEEN-ROWS) 
            (- rows 1)
            cols))]))

;;;; Tests
(check-expect (invader-cons-row 10 2 2) 
              (list (make-posn 200 10) (make-posn 250 10) 
                    (make-posn 200 45) (make-posn 250 45)))


;;;; draw-score: World -> Image
(define TOP-CENTER (make-posn (/ CANVAS-WIDTH 2) 40))

(define (draw-score score img)
  (place-image
    (text (number->string score) 20 "black")
    (posn-x TOP-CENTER)
    (posn-y TOP-CENTER)
    img))

;;;; draw-lives: Spaceship -> Image
(define BOTTOM-RIGHT-CORNER (make-posn (- CANVAS-WIDTH  30)
                                       (- CANVAS-HEIGHT 30)))
(define (draw-lives spaceship img)
  (place-image
    (text (number->string (spaceship-lives spaceship)) 28 "red")
    (posn-x BOTTOM-RIGHT-CORNER)
    (posn-y BOTTOM-RIGHT-CORNER)
    img))


;;;; draw-lopsn: LoP Image Image -> Image
(define (draw-lopsn posns base-img shape-img)
  (local (
    ;;;; draw-posn: Posn Image -> Image
    (define (draw-posn posn image)
      (place-image 
           shape-img
           (posn-x posn)
           (posn-y posn)
           image)))
    (foldl draw-posn base-img posns)))

;;;; Tests
(check-expect (draw-lopsn INVADERS-1 BACKGROUND INVADER-RECT)
              (place-image INVADER-RECT 50 40
                           (place-image INVADER-RECT 250 50 BACKGROUND)))


;;;; Signature
;; draw-invaders: LoF<Invader> Image -> Image

;;;; Purpose
;; GIVEN: a list of invaders and an image
;; RETURNS: a new image with the invaders on the given image

(define (draw-invaders invaders img)
  (draw-lopsn invaders img INVADER-RECT))

;;;; Tests
(check-expect (draw-invaders INVADERS-1 BACKGROUND)
              (place-image INVADER-RECT 50 40
                           (place-image INVADER-RECT 250 50 BACKGROUND)))

;;;; Signature
;; draw-spaceship: Spaceship Image -> Image

;;;; Purpose
;; GIVEN: a spaceship and an image
;; RETURNS: a new image that draws the spaceship on the given image 

(define (draw-spaceship spaceship img)
  (place-image
   SPACESHIP-RECT
   (posn-x (spaceship-position spaceship))
   (posn-y (spaceship-position spaceship))
   img))

;;;; Tests
(check-expect (draw-spaceship SPACESHIP-INIT BACKGROUND)
              (place-image SPACESHIP-RECT 
                           (/ CANVAS-WIDTH 2)
                           (- CANVAS-HEIGHT 20)
                           BACKGROUND))

;;;; Signature
;; draw-sbullets: SBullets Image -> Image

;;;; Purpose
;; GIVEN: a list of spaceship bullets and an image
;; RETURNS: a new image that draws the list of 
;;          spaceship bullets on the given image

(define (draw-sbullets sbullets img)
  (draw-lopsn sbullets img BULLET-RED))

;;;; Tests
(check-expect (draw-sbullets LoPSN-1 BACKGROUND)
              (place-image BULLET-RED 50 100
                           (place-image BULLET-RED 50 200 BACKGROUND)))


;;;; Signature
;; draw-ibullets: IBullets Image -> Image

;;;; Purpose
;; GIVEN: a list of invader bullets and an image
;; RETURNS: a new image that draws the list of 
;;          invader bullets on the given image

(define (draw-ibullets ibullets img)
  (draw-lopsn ibullets img BULLET-BLK))

;;;; Tests
(check-expect (draw-ibullets LoPSN-1 BACKGROUND)
              (place-image BULLET-BLK 50 100
                           (place-image BULLET-BLK 50 200 BACKGROUND)))



;;;; Signature
;; draw-world : World -> Image

;;;; Purpose
;; GIVEN: a world 
;; RETURNS: an image representation of the given world 

(define (draw-world world)
  (draw-invaders (world-invaders world)
                 (draw-spaceship (world-spaceship world)
                                 (draw-sbullets (world-sbullets world) 
                                                (draw-ibullets 
                                                 (world-ibullets world) 
                                                 (draw-lives (world-spaceship world)
                                                  (draw-score (world-score world) BACKGROUND)))))))

;;;; Tests
;; TODO: fix this test
; (check-expect (draw-world WORLD-TEST)
;   (place-image INVADER-RECT 50 100
;      (place-image SPACESHIP-RECT 300 10
;         (place-image BULLET-RED 50 40
;           (place-image BULLET-BLK 250 50 
;             (place-image
;               (text (number->string MAX-LIVES) 28 "red")
;               (posn-x BOTTOM-RIGHT-CORNER)
;               (posn-y BOTTOM-RIGHT-CORNER)
;               BACKGROUND))))))


;;;; Signature
;; spaceship-reach-left-corner?: Spaceship -> Boolean

;;;; Purpose
;; GIVEN: a spaceship
;; RETURNS: true if the spaceship reaches the left corner, false otherwise

(define (spaceship-reach-left-corner? spaceship)
  (<= (- (posn-x (spaceship-position spaceship)) (/ SPACESHIP-L 2)) 0))

;;;; Tests
(check-expect 
 (spaceship-reach-left-corner? 
  (make-spaceship (make-posn 15 200) 'left MAX-LIVES)) #true)
(check-expect 
 (spaceship-reach-left-corner? 
  (make-spaceship (make-posn (+ 15 1) 200) 'left MAX-LIVES)) #false)

;;;; Signature
;; spaceship-reach-right-corner?: Spaceship -> Boolean

;;;; Purpose
;; GIVEN: a spaceship
;; RETURNS: true if the spaceship reaches the right corner, false otherwise

(define (spaceship-reach-right-corner? spaceship)
  (>= (+ (posn-x (spaceship-position spaceship)) (/ SPACESHIP-L 2)) 
      CANVAS-WIDTH))

;;;; Tests
(check-expect 
 (spaceship-reach-right-corner? 
  (make-spaceship (make-posn (- 450 15) 200) 'left MAX-LIVES)) #true)
(check-expect 
 (spaceship-reach-right-corner? 
  (make-spaceship (make-posn (- 450 15 1) 200) 'left MAX-LIVES)) #false)


;;;; Signature
;; spaceship-reach-corner?: Spaceship -> Boolean

;;;; Purpose
;; GIVEN: a spaceship
;; RETURNS: true if the spaceship reaches the left or right corner, 
;;          false otherwise

(define (spaceship-reach-corner? spaceship)
  (or 
   (spaceship-reach-left-corner?  spaceship)
   (spaceship-reach-right-corner? spaceship)))

;;;; Tests
(check-expect 
 (spaceship-reach-corner? 
  (make-spaceship (make-posn 15 200) 'left MAX-LIVES)) #true)
(check-expect 
 (spaceship-reach-corner? 
  (make-spaceship (make-posn (+ 15 1) 200) 'left MAX-LIVES)) #false)
(check-expect 
 (spaceship-reach-corner? 
  (make-spaceship (make-posn (- 450 15) 200) 'left MAX-LIVES)) #true)
(check-expect 
 (spaceship-reach-corner? 
  (make-spaceship (make-posn (- 450 15 1) 200) 'left MAX-LIVES)) #false)


;;;; Signature
;; move-spaceship: Spaceship -> Spaceship

;;;; Purpose
;; GIVEN: a spaceship
;; RETURNS: the spaceship after it moves by one unit distance in the
;;          correct direction, or the original spaceship if it reaches corner

(define (move-spaceship spaceship)
  (cond
    [(spaceship-reach-corner? spaceship)  spaceship]
    [(symbol=? (spaceship-direction spaceship) 'left)
     (make-spaceship
      (make-posn (- (posn-x (spaceship-position spaceship)) UNIT)
                 (posn-y (spaceship-position spaceship)))
      'left
      (spaceship-lives spaceship))]
    [(symbol=? (spaceship-direction spaceship) 'right)
     (make-spaceship
      (make-posn (+ (posn-x (spaceship-position spaceship)) UNIT)
                 (posn-y (spaceship-position spaceship)))
      'right
      (spaceship-lives spaceship))]))

;;;; Tests
(check-expect (move-spaceship
               (make-spaceship (make-posn 15 200) 'left MAX-LIVES))
              (make-spaceship (make-posn 15 200) 'left MAX-LIVES))
(check-expect (move-spaceship
               (make-spaceship (make-posn 25 200) 'left MAX-LIVES))
              (make-spaceship (make-posn 15 200) 'left MAX-LIVES))
(check-expect (move-spaceship
               (make-spaceship (make-posn (- 450 15) 200) 'right MAX-LIVES))
              (make-spaceship (make-posn (- 450 15) 200) 'right MAX-LIVES))
(check-expect (move-spaceship
               (make-spaceship (make-posn (- 450 25) 200) 'right MAX-LIVES))
              (make-spaceship (make-posn (- 450 15) 200) 'right MAX-LIVES))

;;;; spaceship-step: World -> Spaceship
(define (spaceship-step world)
  (local ((define moved-spaceship (move-spaceship (world-spaceship world))))
    (if (spaceship-is-hit? moved-spaceship (world-ibullets world))
      (make-spaceship  ;; if hit, re-init the spaceship with a life less
        (spaceship-position  SPACESHIP-INIT)
        (spaceship-direction SPACESHIP-INIT)
        (- (spaceship-lives moved-spaceship) 1))
      moved-spaceship)))

;;;; Signature
;; move-sbullets: SBullets -> SBullets

;;;; Purpose
;; GIVEN: a list of spaceship bullets
;; RETURNS: a list of spaceship bullets after they move by one unit distance 
;;          in the correct direction

(define (move-sbullets sbullets)
  (cond
    [(empty? sbullets) empty]
    [else
      (local (
             ;;;; Signature
             ;; move-sbullet : LoF<SBullet> -> LoF<SBullet>
             (define (move-sbullet sbullet)
                (make-posn (posn-x sbullet)
                      (- (posn-y sbullet) UNIT))))
      (map move-sbullet sbullets))]))

;;;; Tests
(check-expect (move-sbullets
               (list (make-posn 25 200) (make-posn 25 190)))
              (list (make-posn 25 190) (make-posn 25 180)))


;;;; Signature
;; move-ibullets: IBullets -> IBullets

;;;; Purpose
;; GIVEN: a list of invader bullets
;; RETURNS: a list of invader bullets after they move by one unit distance 
;;          in the correct direction

(define (move-ibullets ibullets)
  (cond
    [(empty? ibullets) empty]
    [else 
      (local (
             ;;;; Signature
             ;; move-ibullet : LoF<IBullet> -> LoF<IBullet>
             (define (move-ibullet ibullet)
                (make-posn (posn-x ibullet)
                      (+ (posn-y ibullet) UNIT))))
      (map move-ibullet ibullets))]))

;;;; Tests
(check-expect (move-ibullets
               (list (make-posn 25 200) (make-posn 25 190)))
              (list (make-posn 25 210) (make-posn 25 200)))


;;;; Signature
;; key-handler: World Key-Event -> World

;;;; Purpose
;; GIVEN: the current world and a key event
;; RETURNS: a new world with spaceship or its bullets updated
;;          according to the key event

(define INVADERS-4-9 (invader-cons-row (* 2 GAP-BETWEEN-ROWS) 
                                       ROW-NUM-INVADER COL-NUM-INVADER))
(define WORLD-TEST-KH-1-BFR 
  (make-world INVADERS-4-9 ;; spaceship reach right corner
              (make-spaceship (make-posn (- 450 15) 200) 'left MAX-LIVES)
              (list (make-posn 0 0))
              (list (make-posn 9 9)) MIN-SCORE TICK-ZERO))
(define WORLD-TEST-KH-1-AFT 
  (make-world INVADERS-4-9 
              (make-spaceship (make-posn (- 450 15 10) 200) 'left MAX-LIVES)
              (list (make-posn 0 0))
              (list (make-posn 9 9)) MIN-SCORE TICK-ZERO))
(define WORLD-TEST-KH-2-BFR 
  (make-world INVADERS-4-9 ;; spaceship reach left corner
              (make-spaceship (make-posn 15 200) 'left MAX-LIVES)
              (list (make-posn 0 0))
              (list (make-posn 9 9)) MIN-SCORE TICK-ZERO))
(define WORLD-TEST-KH-2-AFT 
  (make-world INVADERS-4-9 
              (make-spaceship (make-posn (+ 15 10) 200) 'right MAX-LIVES)
              (list (make-posn 0 0))
              (list (make-posn 9 9)) MIN-SCORE TICK-ZERO))

(define WORLD-TEST-KH-3-BFR 
  (make-world INVADERS-4-9
              (make-spaceship (make-posn (- 450 10) 200) 'left MAX-LIVES)
              (list (make-posn 0 0))
              (list (make-posn 9 9)) MIN-SCORE TICK-ZERO))
(define WORLD-TEST-KH-3-AFT 
  (make-world INVADERS-4-9 
              (make-spaceship (make-posn (- 450 10) 200) 'right MAX-LIVES)
              (list (make-posn 0 0))
              (list (make-posn 9 9)) MIN-SCORE TICK-ZERO))
(define WORLD-TEST-KH-4-BFR 
  (make-world INVADERS-4-9 
              (make-spaceship (make-posn 0 0) 'right MAX-LIVES)
              empty
              empty MIN-SCORE TICK-ZERO))
(define WORLD-TEST-KH-4-AFT 
  (make-world INVADERS-4-9 
              (make-spaceship (make-posn 0 0) 'right MAX-LIVES)
              (list (make-posn 0 0))
              empty MIN-SCORE TICK-ZERO))


;;>Not sure why you need two different conditions just for the arrow key left
;;>and right? Why need the first two cond clauses while for third one can easily
;;>replace them. I mean it's your design so you might have a better explanation
;;>than me. 

;; - Because when the spaceship reaches the left or right corner, 
;; - I'll have to explicitly ask it to move if key pressed, or
;; - it will always stay still because that's what I ask it to do 
;; - in the move-spaceship function. Not sure if there is a better
;; - way to do this.

;;;; Function Definition
(define (key-handler world ke)
  (cond 
    [(and (spaceship-reach-left-corner? (world-spaceship world))
          (key=? ke "right"))
     (make-world (world-invaders world)
                 (make-spaceship
                  (make-posn (+ 
                             (posn-x (spaceship-position 
                                      (world-spaceship world))) UNIT)
                             (posn-y (spaceship-position 
                                      (world-spaceship world))))
                  'right
                  (spaceship-lives (world-spaceship world)))
                 (world-sbullets world)
                 (world-ibullets world)
                 (world-score world)
                 (world-ticks world))]
    [(and (spaceship-reach-right-corner? (world-spaceship world))
          (key=? ke "left"))
     (make-world (world-invaders world)
                 (make-spaceship
                  (make-posn (- 
                              (posn-x (spaceship-position 
                                        (world-spaceship world))) UNIT)
                             (posn-y (spaceship-position 
                                        (world-spaceship world))))
                  'left
                  (spaceship-lives (world-spaceship world)))
                 (world-sbullets world)
                 (world-ibullets world)
                 (world-score world)
                 (world-ticks world))]
    [(or (key=? ke "left")
         (key=? ke "right"))
     (make-world (world-invaders world)
                 (make-spaceship 
                  (spaceship-position (world-spaceship world))
                  (string->symbol ke)
                  (spaceship-lives (world-spaceship world)))
                 (world-sbullets world)
                 (world-ibullets world)
                 (world-score world)
                 (world-ticks world))]
    [(and (key=? ke " ") 
          (< (length (world-sbullets world)) BULLET-MAX-SPACESHIP))
     (make-world (world-invaders world)
                 (world-spaceship world)
                 (cons (spaceship-position (world-spaceship world))
                       (world-sbullets world))
                 (world-ibullets world)
                 (world-score world)
                 (world-ticks world))]
    [else world]))

;;;; Tests
(check-expect (key-handler WORLD-TEST-KH-1-BFR "left") WORLD-TEST-KH-1-AFT)
(check-expect (key-handler WORLD-TEST-KH-2-BFR "right") WORLD-TEST-KH-2-AFT)
(check-expect (key-handler WORLD-TEST-KH-3-BFR "right") WORLD-TEST-KH-3-AFT)
(check-expect (key-handler WORLD-TEST-KH-3-BFR "up") WORLD-TEST-KH-3-BFR)
(check-expect (key-handler WORLD-TEST-KH-4-BFR " ") WORLD-TEST-KH-4-AFT)

;;;; Signature
;; world-step: World -> World

;;;; Purpose
;; GIVEN: the current world
;; RETURNS: the next world after one clock tick -
;;   1. If any of the spaceship or invader bullets go out of bounds,
;;      they will be removed from the canvas.
;;   2. If a spaceship bullet hits an invader, 
;;      it needs to be removed from the canvas.
;;   2. For the spaceship, it will be moved to the next world-step position
;;   3. Any of the invaders that are hit by the spaceship
;;      bullets will be removed from the canvas
;;   4. For all other spaceship and invader bullets, 
;;      they just move to the next world-step position.

;;>-2 You need to be more specific about RETURNS? what kinds of next world
;;>should I expect? how will each game's objects behave?
;;>Plus You must have tests for this IMPORTANT function. I do not mind if
;;>you have skipped other function's tests, but this one is like the heart of
;;>the game and I know it might be a little complicated to test, you must have
;;>it. One test for it should be suffice. 

;;;; Function Definition
(define (world-step world)
  (local ((define spaceship
            (spaceship-step world))
          (define invaders
            (world-invaders world))
          (define remove-lst 
            (filter-sbullets-and-invaders-to-be-removed 
                 (move-sbullets (world-sbullets world))
                 invaders))
          (define invaders-updated
            (remove-sbullets-or-invaders-after-hit
                    invaders
                    remove-lst)))

  (remove-bullets-out-of-bounds-world
     (make-world invaders-updated
                 spaceship
                 (remove-sbullets-or-invaders-after-hit
                    (move-sbullets (world-sbullets world))
                    remove-lst)
                (move-ibullets
                  (remove-ibullet-after-hit
                    spaceship
                    (invaders-fire 
                       (random (length invaders))
                       (world-ibullets world)
                       invaders)))
                (update-score (world-score world)
                              invaders
                              invaders-updated)
                (+ 1 (world-ticks world))))))

;;;; update-score: Score LoF<Invader> LoF<Invader> -> Score
(define (update-score old-score invaders-old invaders-new)
  (local ((define invaders-hit-num
            (- (length invaders-old)
               (length invaders-new))))
  (+ old-score (* UNIT-SCORE invaders-hit-num))))

;;;; Signature
;; posn=?: Posn Posn -> Boolean

;;;; Purpose
;; GIVEN: two posns
;; RETURNS: true if the two posns have the same coordinates, false otherwise

(define (posn=? p1 p2)
  (and (= (posn-x p1) (posn-x p2))
       (= (posn-y p1) (posn-y p2))))

;;;; Tests
(check-expect (posn=? POSN-50-100 POSN-50-100) #true)
(check-expect (posn=? POSN-50-100 POSN-50-200) #false)

;;;; Signature
;; sbullet-over-invader? Posn Posn -> Boolean
(define (sbullet-over-invader? sbullet invader)
  (and
     (< (- (posn-y sbullet)  BULLET-RADIUS)
        (+ (posn-y invader) (/ INVADER-LENGTH 2)))
     (> (+ (posn-x sbullet)  BULLET-RADIUS)
        (- (posn-x invader) (/ INVADER-LENGTH 2)))
     (< (- (posn-x sbullet)  BULLET-RADIUS)
        (+ (posn-x invader) (/ INVADER-LENGTH 2)))))

;;;; Signature
;; sbullet-hits-invaders?: Bullet Invaders -> Boolean

;;;; Purpose
;; GIVEN: a spaceshit bullet and a list of invaders
;; RETURNS: true if the bullet given hits any invader in the list, 
;;          false otherwise

(define (sbullet-hits-invaders? sbullet invaders)
  (ormap
    ;;;; Posn -> Boolean
    (lambda (invader) 
      (sbullet-over-invader? sbullet invader))
    invaders))

;;;; Tests
(check-expect (sbullet-hits-invaders? BULLET-250-65 INVADERS-1) #true)
(check-expect (sbullet-hits-invaders? BULLET-250-66 INVADERS-1) #false)
(check-expect (sbullet-hits-invaders? BULLET-265-65 INVADERS-1) #true)
(check-expect (sbullet-hits-invaders? BULLET-266-65 INVADERS-1) #false)


(define (invader-gets-hit? sbullets invader)
  (ormap 
    ;;;; Posn -> Boolean
    (lambda (sbullet)
      (sbullet-over-invader? sbullet invader))
    sbullets))

;;;; Data Definition
;; A BulletsOrInvaders is a LoF<Posn>
;; INTERP: represents a list containing bullets or (and) invaders

;;;; Signature
;; filter-sbullets-and-invaders-to-be-removed: LoF<Posn> LoF<Posn> -> LoF<Posn>

;;;; Purpose
;; GIVEN: a list of spaceship bullets and a list of invaders
;; RETURNS: a single list containing spaceship bullets and invaders
;;          to be removed

(define (filter-sbullets-and-invaders-to-be-removed sbullets invaders)
  (append
    ;;;; Posn -> Boolean
    (filter (lambda (s) (sbullet-hits-invaders? s invaders)) sbullets)
    (filter (lambda (i) (invader-gets-hit? sbullets i)) invaders)))

(define LoPSN-3 (list POSN-1 POSN-2 POSN-3 POSN-4))
(define LoPSN-4 (list POSN-2 POSN-3 POSN-4 POSN-5))
(define LoPSN-5 (list POSN-2 POSN-3 POSN-4 POSN-2 POSN-3 POSN-4))

;;;; Tests
(check-expect (filter-sbullets-and-invaders-to-be-removed LoPSN-3 LoPSN-4) 
              LoPSN-5)

;;;; Signature
;; lop-contains-posn?: LoF<Posn> Posn -> Boolean

;;;; Purpose
;; GIVEN: a list of posns and a posn
;; RETURNS: true if the given posn is in the list, false otherwise

(define (lop-contains-posn? lop posn)
         ;;;; Posn -> Boolean
  (ormap (lambda (p) (posn=? p posn)) lop))

;;;; Tests
(check-expect (lop-contains-posn? LoPSN-2 POSN-50-300) #true)
(check-expect (lop-contains-posn? LoPSN-2 POSN-50-200) #true)
(check-expect (lop-contains-posn? LoPSN-2 POSN-266-65) #false)


;;;; Signature
;; remove-sbullets-or-invaders-after-hit: BulletsOrInvaders BulletsOrInvaders -> BulletsOrInvaders

;;>-1 I am a little confused. Should LoP be BulletsOrInvaders instead? based
;;>on what you described for the Purpose? 


;;;; Purpose
;; GIVEN: a list of posns (spaceship bullets or invaders) and 
;;        a list spaceship bullets and invaders to be removed
;;; RETURNS: a list of posns (bullets or invaders) after removals

(define (remove-sbullets-or-invaders-after-hit
         sbullets-or-invaders s-and-i-to-be-removed)
  (filter
    ;;;; Posn -> Boolean
    (lambda (s-or-i)
      (not (lop-contains-posn? s-and-i-to-be-removed s-or-i))) 
    sbullets-or-invaders))

;;;; Tests
(check-expect (remove-sbullets-or-invaders-after-hit LoPSN-3 LoPSN-5) 
              (list POSN-1))

;;;; Signature
;; bullet-out-of-bounds?: Bullet -> Boolean

;;;; Purpose
;; GIVEN: a bullet
;; RETURNS: true if the bullet is out of the canvas, false otherwise

(define BULLET-10-UP-IN (make-posn 10 -2))
(define BULLET-10-UP-OUT (make-posn 10 -3))
(define BULLET-10-LO-IN (make-posn 10 602))
(define BULLET-10-LO-OUT (make-posn 10 603))

(define (bullet-out-of-bounds? bullet)
  (or (<= (+ (posn-y bullet) BULLET-RADIUS) 0)
      (>= (- (posn-y bullet) BULLET-RADIUS) CANVAS-HEIGHT)))

;;;; Tests
(check-expect (bullet-out-of-bounds? BULLET-10-UP-IN) #false)
(check-expect (bullet-out-of-bounds? BULLET-10-UP-OUT) #true)
(check-expect (bullet-out-of-bounds? BULLET-10-LO-IN) #false)
(check-expect (bullet-out-of-bounds? BULLET-10-LO-OUT) #true)

;;;; Signature
;; remove-bullets-out-of-bounds: Bullets -> Bullets

;;;; Purpose
;; GIVEN: a list of bullets
;; RETURNS: a new list of bullets with the ones out of bounds removed

(define BULLETS-BFR (list BULLET-10-UP-IN BULLET-10-UP-OUT 
                          BULLET-10-LO-IN BULLET-10-LO-OUT))
(define BULLETS-AFT (list BULLET-10-UP-IN BULLET-10-LO-IN))

(define (remove-bullets-out-of-bounds bullets)
           ;;;; Posn -> Boolean
  (filter (lambda (b) (not (bullet-out-of-bounds? b))) bullets))

;;;; Tests
(check-expect (remove-bullets-out-of-bounds BULLETS-BFR) BULLETS-AFT)
(check-expect (remove-bullets-out-of-bounds (list BULLET-10-LO-IN)) 
              (list BULLET-10-LO-IN))
(check-expect (remove-bullets-out-of-bounds (list BULLET-10-LO-OUT)) empty)

;;;; Signature
;; remove-bullets-out-of-bounds-world: World -> World

;;;; Purpose
;; GIVEN: a world
;; RETURNS: a new world in which the spaceship and invader bullets that are
;;          out of bounds are removed

(define WORLD-TEST-BFR (make-world empty 
                        (make-spaceship POSN-2 'left MAX-LIVES) 
                          BULLETS-BFR BULLETS-BFR MIN-SCORE TICK-ZERO))
(define WORLD-TEST-AFT (make-world empty 
                        (make-spaceship POSN-2 'left MAX-LIVES) 
                          BULLETS-AFT BULLETS-AFT MIN-SCORE TICK-ZERO))

(define (remove-bullets-out-of-bounds-world world)
  (make-world
   (world-invaders world)
   (world-spaceship world)
   (remove-bullets-out-of-bounds (world-sbullets world))
   (remove-bullets-out-of-bounds (world-ibullets world))
   (world-score world)
   (world-ticks world)))

;;;; Tests
(check-expect (remove-bullets-out-of-bounds-world WORLD-TEST-BFR) 
              WORLD-TEST-AFT)

;;;; Signature
;; invader-at: Invaders NonNegInt -> Invader

;;;; Purpose
;; GIVEN: a list of invaders and an (zero-based) index of the invader 
;;        the user wants to pull out
;; RETURNS: the invader in the list with that index

(define (invader-at invaders index)
  (cond
    [(empty? invaders) empty]
    [(= 0 index) (first invaders)]
    [else (invader-at (rest invaders) (- index 1))]))

;;;; Tests
(check-expect (invader-at LoPSN-2 2) POSN-50-300)
(check-expect (invader-at LoPSN-2 5) empty)

;;;; Signature
;; invaders-fire: Natural IBullets Invaders -> IBullets

;;;; Purpose
;; GIVEN: a natural number, a list of invader bullets and a list of invaders
;; RETURNS: a new list of invader bullets with newly-fired bullets added

(define (invaders-fire amount ibullets invaders)
  (cond
    [(or 
      (> (+ (length ibullets) amount) BULLET-MAX-INVADER)
      (< amount 1)) ibullets]
    [else
     (cons
      (invader-at invaders (random (length invaders)))
      (invaders-fire
       (- amount 1)
       ibullets
       invaders))]))

;;;; Tests
(check-expect (invaders-fire 15 BULLETS-AFT INVADERS-4-9) BULLETS-AFT)
(check-expect (invaders-fire 0 BULLETS-AFT INVADERS-4-9) BULLETS-AFT)
(check-random (invaders-fire 1 BULLETS-AFT INVADERS-4-9)
              (cons (invader-at INVADERS-4-9 (random 36)) BULLETS-AFT))

;;;; Signature
;; bullet-hits-spaceship?: Spaceship Bullet -> Boolean

;;;; Purpose
;; GIVEN: a spaceship and a bullet
;; RETURNS: true if that bullet on the canvas hits the spaceship, 
;;          false otherwise

(define (bullet-hits-spaceship? spaceship bullet)
  (and 
   (> (+ (posn-x bullet) BULLET-RADIUS) 
      (- (posn-x (spaceship-position spaceship)) (/ SPACESHIP-L 2)))
   (< (- (posn-x bullet) BULLET-RADIUS) 
      (+ (posn-x (spaceship-position spaceship)) (/ SPACESHIP-L 2)))
   (> (+ (posn-y bullet) BULLET-RADIUS) 
      (- (posn-y (spaceship-position spaceship)) (/ SPACESHIP-W 2)))))

;;;; Tests
(check-expect (bullet-hits-spaceship? SPACESHIP-INIT POSN-BOTTOM-MID) #true)
(check-expect (bullet-hits-spaceship? SPACESHIP-INIT 
                                      (make-posn 400 490)) #false)

;;;; Spaceship LoF<IBullet> -> LoF<IBullet>
(define (remove-ibullet-after-hit spaceship ibullets)
  (filter (lambda (i) (not (bullet-hits-spaceship? spaceship i))) ibullets))

;;;; Signature
;; spaceship-is-hit?: Spaceship Bullets -> Boolean

;;;; Purpose
;; GIVEN: a spaceship and a bullet
;; RETURNS: true if any bullet on the canvas hits the spaceship,
;;          false otherwise

(define (spaceship-is-hit? spaceship ibullets)
  (ormap (lambda (i)  ;;;; Posn -> Boolean
            (bullet-hits-spaceship? spaceship i))
         ibullets))

;;;; Tests
(check-expect (spaceship-is-hit? SPACESHIP-INIT 
                                 (world-ibullets WORLD-INIT)) #false)
(check-expect (spaceship-is-hit? SPACESHIP-INIT 
                                 (list POSN-50-300 POSN-BOTTOM-MID)) #true)

;;;; spaceship-init: Spaceship -> Spaceship
(define (spaceship-init spaceship)
  SPACESHIP-INIT)

;;;; Signature
;; end-game?: World -> Boolean

;;;; Purpose
;; GIVEN: the current world
;; RETURNS: true if the spaceship is hit by any bullets from invaders,
;;          false otherwise

(define (end-game? world)
  (= (spaceship-lives (world-spaceship world)) 0))

;;;; Tests
(check-expect (end-game? WORLD-INIT) #false)
(check-expect (end-game? WORLD-END) #true)


(define POSN-BOTTOM-MID (make-posn (/ CANVAS-WIDTH 2) (- CANVAS-HEIGHT 20)))
(define BULLETS-SPACESHIP (cons POSN-BOTTOM-MID empty))
(define WORLD-INIT (make-world INVADERS-4-9 SPACESHIP-INIT empty empty MIN-SCORE TICK-ZERO))
(define WORLD-END (make-world INVADERS-4-9 SPACESHIP-DEAD empty empty MIN-SCORE TICK-ZERO))

(big-bang WORLD-INIT
          (to-draw draw-world)
          (on-tick world-step 0.1)
          (on-key key-handler)
          (stop-when end-game?))
