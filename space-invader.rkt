;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname space-invader) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;>Total: 85/91

;;>Overall, your design is very detail-oriented and easy to follow.

;;>-1 Must have at least 4 rows of invaders per requirement

;;>-1 You have some magical values such as 1, 'left, ect. floating around.
;;>Might want to clean them up.


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
(define SPACESHIP-DIR-INIT 'right)


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
(define-struct spaceship [position direction])

;; Constructor Template:
;; A Spaceship is a (make-spaceship Posn Direction)
;; INTERP: represents a spaceship on the canvas

;; Examples
(define SPACESHIP-MID (make-spaceship 
                       (make-posn (/ CANVAS-WIDTH 2) (- CANVAS-HEIGHT 20))
                       SPACESHIP-DIR-INIT))

;; Deconstructor Template:
;; spaceship-fn: Spaceship -> ???
#; (define (spaceship-fn spaceship)
     ... (posn-fn (spaceship-position spaceship)) ...
     ... (spaceship-direction spaceship) ... )

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


;; A ListOfInvaders (LoI) is one of
;; - empty
;; - (cons Invader LoI) 
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

;; A ListOfBullets (LoB) is one of
;; - empty
;; - (cons Bullet LoB) 
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

;; An SBullets (LoSB) is a list of SBullet
;; represents a list of bullets from the spaceship

;; An IBullets (LoIB) is a list of IBullet
;; represents a list of bullets from invaders

(define-struct world [invaders spaceship sbullets ibullets])

;; Constructor Template:
;; A World is a (make-world LoI Spaceship LoB LoB)
;; INTERP: invaders represents invaders in the game
;;         spaceship represents a spaceship in the game
;;         sbullets represents bullets from the spaceship in the game
;;         ibullets represents bullets from invaders in the game

;; Examples
(define WORLD-0
  (make-world LOI1 SPACESHIP-MID LOB1 LOB1))
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
(define SPACESHIP-300-10-left (make-spaceship (make-posn 300 10) 'left))
(define WORLD-TEST 
  (make-world (list POSN-50-100) SPACESHIP-300-10-left 
              (list POSN-50-40) (list POSN-250-50)))


;;;; Signature
;; first-x: Natural -> Real

;;;; Purpose
;; GIVEN: a natural number representing the number of columns
;; RETURNS: the appropriate x coordinate value for the first invader in a row

;;;; Examples
;; (first-x 9) => 25

;;;; Function Definition
(define (first-x cols)
  (/ (- CANVAS-WIDTH (* (- cols 1) 2 INVADER-LENGTH)) 2))

;;;; Tests
(check-expect (first-x 9) 25)

;;;; Signature
;; invader-cons-col: Real Real Natural -> LoI

;;;; Purpose
;; GIVEN: an x and a y coordinate value and 
;;        a natural number representing the number of columns
;; RETURNS: a list of invaders assigned with appropriate posns

;;;; Examples
;; (invader-cons-col 10 10 2) => (list (make-posn 10 10) (make-posn 60 10))

;;;; Function Definition
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
;; invader-cons-row: Real Natural Natural-> LoI

;;;; Purpose
;; GIVEN: a y coordinate value, number of rows and number of columns
;; RETURNS: a list of invaders assigned with appropriate posns

;;;; Examples
;; (invader-cons-row 10 2 2) =>
;; (list (make-posn 200 10) (make-posn 250 10) 
;;       (make-posn 200 45) (make-posn 250 45))

;;;; Function Definition
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


;;;; Signature
;; draw-invaders: LoI -> Image

;;;; Purpose
;; GIVEN: a list of invaders and an image
;; RETURNS: a new image with the invaders on the given image

;;;; Examples
;; (draw-invaders INVADERS-1 BACKGROUND) => 
;;   (place-image INVADER-RECT 50 40
;;       (place-image INVADER-RECT 250 50 BACKGROUND))

;;;; Function Definition
(define (draw-invaders invaders img)
  (cond
    [(empty? invaders) img]
    [else (place-image 
           INVADER-RECT
           (posn-x (first invaders))
           (posn-y (first invaders))
           (draw-invaders (rest invaders) img))]))

;;;; Tests
(check-expect (draw-invaders INVADERS-1 BACKGROUND)
              (place-image INVADER-RECT 50 40
                           (place-image INVADER-RECT 250 50 BACKGROUND)))

;;;; Signature
;; draw-spaceship: Spaceship Image -> Image

;;;; Purpose
;; GIVEN: a spaceship and an image
;; RETURNS: a new image that draws the spaceship on the given image 

;;;; Examples
;; (draw-spaceship SPACESHIP-MID BACKGROUND) =>
;;  (place-image SPACESHIP-RECT 
;;    (/ CANVAS-WIDTH 2)
;;    (- CANVAS-HEIGHT 20)
;;    BACKGROUND)


;;;; Function Definition
(define (draw-spaceship spaceship img)
  (place-image
   SPACESHIP-RECT
   (posn-x (spaceship-position spaceship))
   (posn-y (spaceship-position spaceship))
   img))

;;;; Tests
(check-expect (draw-spaceship SPACESHIP-MID BACKGROUND)
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

;;;; Examples
;; (draw-ibullets LoPSN-1 BACKGROUND) => 
;;   (place-image BULLET-RED 50 100
;;       (place-image BULLET-RED 50 200 BACKGROUND))

;;;; Function Definition
(define (draw-sbullets sbullets img)
  (cond
    [(empty? sbullets) img]
    [else (place-image 
           BULLET-RED
           (posn-x (first sbullets))
           (posn-y (first sbullets))
           (draw-sbullets (rest sbullets) img))]))

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

;;;; Examples
;; (draw-ibullets LoPSN-1 BACKGROUND) => 
;;   (place-image BULLET-BLK 50 100
;;       (place-image BULLET-BLK 50 200 BACKGROUND))

;;;; Function Definition
(define (draw-ibullets ibullets img)
  (cond
    [(empty? ibullets) img]
    [else (place-image 
           BULLET-BLK
           (posn-x (first ibullets))
           (posn-y (first ibullets))
           (draw-ibullets (rest ibullets) img))]))

;;;; Tests
(check-expect (draw-ibullets LoPSN-1 BACKGROUND)
              (place-image BULLET-BLK 50 100
                           (place-image BULLET-BLK 50 200 BACKGROUND)))



;;;; Signature
;; draw-world : World -> Image

;;;; Purpose
;; GIVEN: a world 
;; RETURNS: an image representation of the given world 

;;;; Examples
;; (draw-world WORLD-TEST) => 
;;   (place-image INVADER-RECT 50 100
;;     (place-image SPACESHIP-RECT 300 10
;;       (place-image BULLET-RED 50 40
;;         (place-image BULLET-BLK 250 50 BACKGROUND))))
;; 

;;;; Function Definition
(define (draw-world world)
  (draw-invaders (world-invaders world)
                 (draw-spaceship (world-spaceship world)
                                 (draw-sbullets (world-sbullets world) 
                                                (draw-ibullets 
                                                 (world-ibullets world) 
                                                 BACKGROUND)))))

;;;; Tests
(check-expect (draw-world WORLD-TEST)
  (place-image INVADER-RECT 50 100
     (place-image SPACESHIP-RECT 300 10
        (place-image BULLET-RED 50 40
          (place-image BULLET-BLK 250 50 BACKGROUND)))))


;;;; Signature
;; spaceship-reach-left-corner?: Spaceship -> Boolean

;;;; Purpose
;; GIVEN: a spaceship
;; RETURNS: true if the spaceship reaches the left corner, false otherwise

;;;; Examples
;; (spaceship-reach-left-corner? 
;;   (make-spaceship (make-posn 15 200) 'left)) => #true
;; (spaceship-reach-left-corner? 
;;   (make-spaceship (make-posn (+ 15 1) 200) 'left)) => #false


;;;; Function Definition
(define (spaceship-reach-left-corner? spaceship)
  (<= (- (posn-x (spaceship-position spaceship)) (/ SPACESHIP-L 2)) 0))

;;;; Tests
(check-expect 
 (spaceship-reach-left-corner? 
  (make-spaceship (make-posn 15 200) 'left)) #true)
(check-expect 
 (spaceship-reach-left-corner? 
  (make-spaceship (make-posn (+ 15 1) 200) 'left)) #false)

;;;; Signature
;; spaceship-reach-right-corner?: Spaceship -> Boolean

;;;; Purpose
;; GIVEN: a spaceship
;; RETURNS: true if the spaceship reaches the right corner, false otherwise

;;;; Examples
;; (spaceship-reach-right-corner? 
;;   (make-spaceship (make-posn (- 450 15) 200) 'left)) #true)
;; (spaceship-reach-right-corner? 
;;   (make-spaceship (make-posn (- 450 15 1) 200) 'left)) #false)

;;;; Function Definition
(define (spaceship-reach-right-corner? spaceship)
  (>= (+ (posn-x (spaceship-position spaceship)) (/ SPACESHIP-L 2)) 
      CANVAS-WIDTH))

;;;; Tests
(check-expect 
 (spaceship-reach-right-corner? 
  (make-spaceship (make-posn (- 450 15) 200) 'left)) #true)
(check-expect 
 (spaceship-reach-right-corner? 
  (make-spaceship (make-posn (- 450 15 1) 200) 'left)) #false)


;;;; Signature
;; spaceship-reach-corner?: Spaceship -> Boolean

;;;; Purpose
;; GIVEN: a spaceship
;; RETURNS: true if the spaceship reaches the left or right corner, 
;;          false otherwise

;;;; Examples
;; (check-expect
;;   (spaceship-reach-corner? 
;;     (make-spaceship (make-posn 15 200) 'left)) #true)
;; (check-expect 
;;   (spaceship-reach-corner? 
;;     (make-spaceship (make-posn (+ 15 1) 200) 'left)) #false)
;; (check-expect 
;;   (spaceship-reach-corner? 
;;     (make-spaceship (make-posn (- 450 15) 200) 'left)) #true)
;; (check-expect 
;;   (spaceship-reach-corner? 
;;    (make-spaceship (make-posn (- 450 15 1) 200) 'left)) #false)

;;;; Function Definition
(define (spaceship-reach-corner? spaceship)
  (or 
   (spaceship-reach-left-corner?  spaceship)
   (spaceship-reach-right-corner? spaceship)))

;;;; Tests
(check-expect 
 (spaceship-reach-corner? 
  (make-spaceship (make-posn 15 200) 'left)) #true)
(check-expect 
 (spaceship-reach-corner? 
  (make-spaceship (make-posn (+ 15 1) 200) 'left)) #false)
(check-expect 
 (spaceship-reach-corner? 
  (make-spaceship (make-posn (- 450 15) 200) 'left)) #true)
(check-expect 
 (spaceship-reach-corner? 
  (make-spaceship (make-posn (- 450 15 1) 200) 'left)) #false)


;;;; Signature
;; move-spaceship: Spaceship -> Spaceship

;;;; Purpose
;; GIVEN: a spaceship
;; RETURNS: the spaceship after it moves by one unit distance in the
;;          correct direction, or the original spaceship if it reaches corner

;;;; Examples
;; (move-spaceship
;;   (make-spaceship (make-posn 15 200) 'left)) => 
;;       (make-spaceship (make-posn 15 200) 'left)
;; (move-spaceship
;;   (make-spaceship (make-posn 25 200) 'left)) => 
;;       (make-spaceship (make-posn 15 200) 'left)
;; (move-spaceship
;;   (make-spaceship (make-posn (- 450 15) 200) 'right)) => 
;;       (make-spaceship (make-posn (- 450 15) 200) 'right)
;; (move-spaceship
;;   (make-spaceship (make-posn (- 450 25) 200) 'right)) => 
;;       (make-spaceship (make-posn (- 450 15) 200) 'right)

;;;; Function Definition
(define (move-spaceship spaceship)
  (cond
    [(spaceship-reach-corner? spaceship)  spaceship]
    [(symbol=? (spaceship-direction spaceship) 'left)
     (make-spaceship
      (make-posn (- (posn-x (spaceship-position spaceship)) UNIT)
                 (posn-y (spaceship-position spaceship)))
      'left)]
    [(symbol=? (spaceship-direction spaceship) 'right)
     (make-spaceship
      (make-posn (+ (posn-x (spaceship-position spaceship)) UNIT)
                 (posn-y (spaceship-position spaceship)))
      'right)]))

;;;; Tests
(check-expect (move-spaceship
               (make-spaceship (make-posn 15 200) 'left))
              (make-spaceship (make-posn 15 200) 'left))
(check-expect (move-spaceship
               (make-spaceship (make-posn 25 200) 'left))
              (make-spaceship (make-posn 15 200) 'left))
(check-expect (move-spaceship
               (make-spaceship (make-posn (- 450 15) 200) 'right))
              (make-spaceship (make-posn (- 450 15) 200) 'right))
(check-expect (move-spaceship
               (make-spaceship (make-posn (- 450 25) 200) 'right))
              (make-spaceship (make-posn (- 450 15) 200) 'right))

;;;; Signature
;; move-sbullets: SBullets -> SBullets

;;;; Purpose
;; GIVEN: a list of spaceship bullets
;; RETURNS: a list of spaceship bullets after they move by one unit distance 
;;          in the correct direction

;;;; Examples
;; (move-sbullets
;;   (list (make-posn 25 200) (make-posn 25 190))) => 
;;     (list (make-posn 25 190) (make-posn 25 180))

;;;; Function Definition
(define (move-sbullets sbullets)
  (cond
    [(empty? sbullets) empty]
    [else 
     (cons (make-posn (posn-x (first sbullets))
                      (- (posn-y (first sbullets)) UNIT))
           (move-sbullets (rest sbullets)))]))

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

;;;; Examples
;; (move-ibullets
;;   (list (make-posn 25 200) (make-posn 25 190))) => 
;;     (list (make-posn 25 210) (make-posn 25 200))

;;;; Function Definition
(define (move-ibullets ibullets)
  (cond
    [(empty? ibullets) empty]
    [else 
     (cons (make-posn (posn-x (first ibullets))
                      (+ (posn-y (first ibullets)) UNIT))
           (move-ibullets (rest ibullets)))]))

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
              (make-spaceship (make-posn (- 450 15) 200) 'left)
              (list (make-posn 0 0))
              (list (make-posn 9 9))))
(define WORLD-TEST-KH-1-AFT 
  (make-world INVADERS-4-9 
              (make-spaceship (make-posn (- 450 15 10) 200) 'left)
              (list (make-posn 0 0))
              (list (make-posn 9 9))))
(define WORLD-TEST-KH-2-BFR 
  (make-world INVADERS-4-9 ;; spaceship reach left corner
              (make-spaceship (make-posn 15 200) 'left)
              (list (make-posn 0 0))
              (list (make-posn 9 9))))
(define WORLD-TEST-KH-2-AFT 
  (make-world INVADERS-4-9 
              (make-spaceship (make-posn (+ 15 10) 200) 'right)
              (list (make-posn 0 0))
              (list (make-posn 9 9))))

(define WORLD-TEST-KH-3-BFR 
  (make-world INVADERS-4-9
              (make-spaceship (make-posn (- 450 10) 200) 'left)
              (list (make-posn 0 0))
              (list (make-posn 9 9))))
(define WORLD-TEST-KH-3-AFT 
  (make-world INVADERS-4-9 
              (make-spaceship (make-posn (- 450 10) 200) 'right)
              (list (make-posn 0 0))
              (list (make-posn 9 9))))
(define WORLD-TEST-KH-4-BFR 
  (make-world INVADERS-4-9 
              (make-spaceship (make-posn 0 0) 'right)
              empty
              empty))
(define WORLD-TEST-KH-4-AFT 
  (make-world INVADERS-4-9 
              (make-spaceship (make-posn 0 0) 'right)
              (list (make-posn 0 0))
              empty))

;;;; Examples
;; (key-handler WORLD-TEST-KH-1-BFR "left") => WORLD-TEST-KH-1-AFT
;; (key-handler WORLD-TEST-KH-2-BFR "right") => WORLD-TEST-KH-2-AFT
;; (key-handler WORLD-TEST-KH-3-BFR "right") => WORLD-TEST-KH-3-AFT
;; (key-handler WORLD-TEST-KH-3-BFR "up") => WORLD-TEST-KH-3-BFR
;; (key-handler WORLD-TEST-KH-4-BFR " ") => WORLD-TEST-KH-4-AFT


;;>Not sure why you need two different conditions just for the arrow key left
;;>and right? Why need the first two cond clauses while for third one can easily
;;>replace them. I mean it's your design so you might have a better explanation
;;>than me. 

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
                  'right)
                 (world-sbullets world)
                 (world-ibullets world))]
    [(and (spaceship-reach-right-corner? (world-spaceship world))
          (key=? ke "left"))
     (make-world (world-invaders world)
                 (make-spaceship
                  (make-posn (- 
                              (posn-x (spaceship-position 
                                        (world-spaceship world))) UNIT)
                             (posn-y (spaceship-position 
                                        (world-spaceship world))))
                  'left)
                 (world-sbullets world)
                 (world-ibullets world))]
    [(or (key=? ke "left")
         (key=? ke "right"))
     (make-world (world-invaders world)
                 (make-spaceship 
                  (spaceship-position (world-spaceship world))
                  (string->symbol ke))
                 (world-sbullets world)
                 (world-ibullets world))]
    [(and (key=? ke " ") 
          (< (length (world-sbullets world)) BULLET-MAX-SPACESHIP))
     (make-world (world-invaders world)
                 (world-spaceship world)
                 (cons (spaceship-position (world-spaceship world))
                       (world-sbullets world))
                 (world-ibullets world))]
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
;; RETURNS: the next world after one clock tick

;;>-2 You need to be more specific about RETURNS? what kinds of next world
;;>should I expect? how will each game's objects behave?
;;>Plus You must have tests for this IMPORTANT function. I do not mind if
;;>you have skipped other function's tests, but this one is like the heart of
;;>the game and I know it might be a little complicated to test, you must have
;;>it. One test for it should be suffice. 

;;;; Function Definition
(define (world-step world)
  (remove-bullets-out-of-bounds-world
   (make-world (remove-sbullets-or-invaders-after-hit
                (world-invaders world)
                (filter-sbullets-and-invaders-to-be-removed 
                 (move-sbullets (world-sbullets world))
                 (world-invaders world)))
               (move-spaceship (world-spaceship world))
               (remove-sbullets-or-invaders-after-hit
                (move-sbullets (world-sbullets world))
                (filter-sbullets-and-invaders-to-be-removed 
                 (move-sbullets (world-sbullets world))
                 (world-invaders world)))
               (move-ibullets
                (invaders-fire 
                 (random (length (world-invaders world)))
                 (world-ibullets world)
                 (world-invaders world))))))

;;;; Signature
;; posn=?: Posn Posn -> Boolean

;;;; Purpose
;; GIVEN: two posns
;; RETURNS: true if the two posns have the same coordinates, false otherwise

;;;; Examples
;; (posn=? POSN-50-100 POSN-50-100) => #true
;; (posn=? POSN-50-100 POSN-50-200) => #false

;;;; Function Definition
(define (posn=? p1 p2)
  (and (= (posn-x p1) (posn-x p2))
       (= (posn-y p1) (posn-y p2))))

;;;; Tests
(check-expect (posn=? POSN-50-100 POSN-50-100) #true)
(check-expect (posn=? POSN-50-100 POSN-50-200) #false)

;;;; Signature
;; remove-posn-in-lop: Posn LoP -> LoP

;;;; Purpose
;; GIVEN: a list of posns and a posn
;; RETURNS: a new list of posns with the given posn removed from the list 

;;;; Examples
;; (remove-posn-in-lop POSN-50-300 LoPSN-2) => LoPSN-1
;; (remove-posn-in-lop POSN-50-300 LoPSN-1) => LoPSN-1

;;;; Function Definition
(define (remove-posn-in-lop posn lop)
  (cond
    [(empty? lop) empty]
    [(posn=? posn (first lop))
     (rest lop)]
    [else
     (cons (first lop) (remove-posn-in-lop posn (rest lop)))]))

;;;; Tests
(check-expect (remove-posn-in-lop POSN-50-300 LoPSN-2) LoPSN-1)
(check-expect (remove-posn-in-lop POSN-50-300 LoPSN-1) LoPSN-1)

;;;; Signature
;; sbullet-hits-invaders?: Bullet Invaders -> Boolean

;;;; Purpose
;; GIVEN: a spaceshit bullet and a list of invaders
;; RETURNS: true if the bullet given hits any invader in the list, 
;;          false otherwise

;;;; Examples
;; (sbullet-hits-invaders? BULLET-250-65 INVADERS-1) => #true
;; (sbullet-hits-invaders? BULLET-250-66 INVADERS-1) => #false
;; (sbullet-hits-invaders? BULLET-265-65 INVADERS-1) => #true
;; (sbullet-hits-invaders? BULLET-266-65 INVADERS-1) => #false

;;;; Function Definition
(define (sbullet-hits-invaders? sbullet invaders)
  (and (cons? invaders)
       (or 
        (and
         (< (- (posn-y sbullet)  BULLET-RADIUS)
            (+ (posn-y (first invaders)) (/ INVADER-LENGTH 2)))
         (> (+ (posn-x sbullet)  BULLET-RADIUS)
            (- (posn-x (first invaders)) (/ INVADER-LENGTH 2)))
         (< (- (posn-x sbullet)  BULLET-RADIUS)
            (+ (posn-x (first invaders)) (/ INVADER-LENGTH 2))))
        (sbullet-hits-invaders? sbullet (rest invaders)))))

;;;; Tests
(check-expect (sbullet-hits-invaders? BULLET-250-65 INVADERS-1) #true)
(check-expect (sbullet-hits-invaders? BULLET-250-66 INVADERS-1) #false)
(check-expect (sbullet-hits-invaders? BULLET-265-65 INVADERS-1) #true)
(check-expect (sbullet-hits-invaders? BULLET-266-65 INVADERS-1) #false)

;;;; Signature
;; invader-that-gets-hit: Bullet Invaders -> Invader

;;;; Purpose
;; GIVEN: a spaceshit bullet and a list of invaders
;; RETURNS: the invader that gets hit

;;;; Examples
;; (invader-that-gets-hit BULLET-250-65 INVADERS-1) => POSN-250-50
;; (invader-that-gets-hit BULLET-250-66 INVADERS-1) => empty
;; (invader-that-gets-hit BULLET-265-65 INVADERS-1) => POSN-250-50

;;>-1 Repetition code. Again, I do not mind you have repetition for
;;>the case of spaceship/invaders' bullets since they move in opposite
;;>direction. Here however, the body of the above fuction
;;>sbullet-hits-invaders? and the one below are almost identical
;;>in term of functionality. Thus you might need helper functions
;;>to reduce that junk. 


;;;; Function Definition
(define (invader-that-gets-hit sbullet invaders)
  (cond
    [(empty? invaders) empty]
    [(and 
      (< (- (posn-y sbullet)  BULLET-RADIUS)
         (+ (posn-y (first invaders)) (/ INVADER-LENGTH 2)))
      (> (+ (posn-x sbullet)  BULLET-RADIUS)
         (- (posn-x (first invaders)) (/ INVADER-LENGTH 2)))
      (< (- (posn-x sbullet)  BULLET-RADIUS)
         (+ (posn-x (first invaders)) (/ INVADER-LENGTH 2))))
     (first invaders)]
    [else
     (invader-that-gets-hit sbullet (rest invaders))]))

;;;; Tests
(check-expect (invader-that-gets-hit BULLET-250-65 INVADERS-1) POSN-250-50)
(check-expect (invader-that-gets-hit BULLET-250-66 INVADERS-1) empty)
(check-expect (invader-that-gets-hit BULLET-265-65 INVADERS-1) POSN-250-50)


;;;; Data Definition
;; A BulletsOrInvaders is a LoP
;; INTERP: represents a list containing bullets or (and) invaders

;;;; Signature
;; filter-sbullets-and-invaders-to-be-removed: 
;;                        SBullets Invaders -> BulletsOrInvaders

;;;; Purpose
;; GIVEN: a list of spaceship bullets and a list of invaders
;; RETURNS: a single list containing spaceship bullets and invaders
;;          to be removed

;;;; Examples
;; (filter-sbullets-and-invaders-to-be-removed LoPSN-3 LoPSN-4) => LoPSN-5

;;;; Function Definition
(define (filter-sbullets-and-invaders-to-be-removed sbullets invaders)
  (cond
    [(empty? sbullets) empty]
    [(sbullet-hits-invaders? (first sbullets) invaders)
     (cons (first sbullets)
           (cons (invader-that-gets-hit (first sbullets) invaders)
                 (filter-sbullets-and-invaders-to-be-removed 
                  (rest sbullets) invaders)))]
    [else (filter-sbullets-and-invaders-to-be-removed 
           (rest sbullets) invaders)]))

(define LoPSN-3 (list POSN-1 POSN-2 POSN-3 POSN-4))
(define LoPSN-4 (list POSN-2 POSN-3 POSN-4 POSN-5))
(define LoPSN-5 (list POSN-2 POSN-2 POSN-3 POSN-3 POSN-4 POSN-4))

;;;; Tests
(check-expect (filter-sbullets-and-invaders-to-be-removed LoPSN-3 LoPSN-4) 
              LoPSN-5)

;;;; Signature
;; lop-contains-posn?: LoP -> Posn

;;;; Purpose
;; GIVEN: a list of posns and a posn
;; RETURNS: true if the given posn is in the list, false otherwise

;;;; Examples
;; (lop-contains-posn? LoPSN-2 POSN-50-300) => #true
;; (lop-contains-posn? LoPSN-2 POSN-50-200) => #true
;; (lop-contains-posn? LoPSN-2 POSN-266-65) => #false

;;;; Function Definition
(define (lop-contains-posn? lop posn)
  (and (cons? lop)
       (or (posn=? posn (first lop))
           (lop-contains-posn? (rest lop) posn))))

;;;; Tests
(check-expect (lop-contains-posn? LoPSN-2 POSN-50-300) #true)
(check-expect (lop-contains-posn? LoPSN-2 POSN-50-200) #true)
(check-expect (lop-contains-posn? LoPSN-2 POSN-266-65) #false)


;;;; Signature
;; remove-sbullets-or-invaders-after-hit: LoP LoP -> LoP

;;>-1 I am a little confused. Should LoP be BulletsOrInvaders instead? based
;;>on what you described for the Purpose? 


;;;; Purpose
;; GIVEN: a list of posns (spaceship bullets or invaders) and 
;;        a list spaceship bullets and invaders to be removed
;;; RETURNS: a list of posns (bullets or invaders) after removals

;;;; Examples
;; (remove-sbullets-or-invaders-after-hit LoPSN-3 LoPSN-5) (list POSN-1)

;;;; Function Definition
(define (remove-sbullets-or-invaders-after-hit
         sbullets-or-invaders sbullets-and-invaders-to-be-removed)
  (cond
    [(empty? sbullets-and-invaders-to-be-removed) sbullets-or-invaders]
    [(lop-contains-posn? sbullets-or-invaders 
                         (first sbullets-and-invaders-to-be-removed))
     (remove-sbullets-or-invaders-after-hit 
      (remove-posn-in-lop 
       (first sbullets-and-invaders-to-be-removed) sbullets-or-invaders)
      (rest sbullets-and-invaders-to-be-removed))]
    [else
     (remove-sbullets-or-invaders-after-hit
      sbullets-or-invaders
      (rest sbullets-and-invaders-to-be-removed))]))

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

;;;; Examples
;; (bullet-out-of-bounds? BULLET-10-UP-IN) => #false
;; (bullet-out-of-bounds? BULLET-10-UP-OUT) => #true
;; (bullet-out-of-bounds? BULLET-10-LO-IN) => #false
;; (bullet-out-of-bounds? BULLET-10-LO-OUT) => #true

;;;; Function Definition
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

;;;; Examples
;; (remove-bullets-out-of-bounds 
;;    BULLETS-BFR) =>
;;         (list BULLET-10-UP-IN BULLET-10-LO-IN))
;; (remove-bullets-out-of-bounds (list BULLET-10-LO-IN)) 
;;                            => (list BULLET-10-LO-IN)
;; (remove-bullets-out-of-bounds (list BULLET-10-LO-OUT)) => empty)

;;;; Function Definition
(define (remove-bullets-out-of-bounds bullets)
  (cond
    [(empty? bullets) empty]
    [(bullet-out-of-bounds? (first bullets))
     (remove-bullets-out-of-bounds (rest bullets))]
    [else
     (cons (first bullets) (remove-bullets-out-of-bounds (rest bullets)))]))

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
                        (make-spaceship POSN-2 'left) 
                          BULLETS-BFR BULLETS-BFR))
(define WORLD-TEST-AFT (make-world empty 
                        (make-spaceship POSN-2 'left) 
                          BULLETS-AFT BULLETS-AFT))

;;;; Examples
;; (remove-bullets-out-of-bounds-world WORLD-TEST-BFR) => WORLD-TEST-AFT

;;;; Function Definition
(define (remove-bullets-out-of-bounds-world world)
  (make-world
   (world-invaders world)
   (world-spaceship world)
   (remove-bullets-out-of-bounds (world-sbullets world))
   (remove-bullets-out-of-bounds (world-ibullets world))))

;;;; Tests
(check-expect (remove-bullets-out-of-bounds-world WORLD-TEST-BFR) 
              WORLD-TEST-AFT)

;;;; Signature
;; invader-at: Invaders NonNegInt -> Invader

;;;; Purpose
;; GIVEN: a list of invaders and an (zero-based) index of the invader 
;;        the user wants to pull out
;; RETURNS: the invader in the list with that index

;;;; Examples
;; (invader-at LoPSN-2 2) => POSN-50-300
;; (invader-at LoPSN-2 5) => empty

;;;; Function Definition
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

;;;; Examples
;; (invaders-fire 15 BULLETS-AFT INVADERS-4-9) => BULLETS-AFT
;; (invaders-fire 0 BULLETS-AFT INVADERS-4-9) => BULLETS-AFT
;; (invaders-fire 1 BULLETS-AFT INVADERS-4-9) =>
;;              (cons (invader-at INVADERS-4-9 (random 36)) BULLETS-AFT)

;;;; Function Definition
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

;;;; Examples
;; (bullet-hits-spaceship? SPACESHIP-MID POSN-BOTTOM-MID) => #true
;; (bullet-hits-spaceship? SPACESHIP-MID (make-posn 400 490)) => #false

;;;; Function Definition
(define (bullet-hits-spaceship? spaceship bullet)
  (and 
   (> (+ (posn-x bullet) BULLET-RADIUS) 
      (- (posn-x (spaceship-position spaceship)) (/ SPACESHIP-L 2)))
   (< (- (posn-x bullet) BULLET-RADIUS) 
      (+ (posn-x (spaceship-position spaceship)) (/ SPACESHIP-L 2)))
   (> (+ (posn-y bullet) BULLET-RADIUS) 
      (- (posn-y (spaceship-position spaceship)) (/ SPACESHIP-W 2)))))

;;;; Tests
(check-expect (bullet-hits-spaceship? SPACESHIP-MID POSN-BOTTOM-MID) #true)
(check-expect (bullet-hits-spaceship? SPACESHIP-MID 
                                      (make-posn 400 490)) #false)

;;;; Signature
;; spaceship-is-hit?: Spaceship Bullets -> Boolean

;;;; Purpose
;; GIVEN: a spaceship and a bullet
;; RETURNS: true if any bullet on the canvas hits the spaceship,
;;          false otherwise

;;;; Examples
;; (spaceship-is-hit? SPACESHIP-MID (world-ibullets WORLD-INIT)) => #false
;; (spaceship-is-hit? SPACESHIP-MID (list POSN-BOTTOM-MID POSN-50-300)) #true

;;;; Function Definition
(define (spaceship-is-hit? spaceship ibullets)
  (and (cons? ibullets)
       (or 
        (bullet-hits-spaceship? spaceship (first ibullets))
        (spaceship-is-hit? spaceship (rest ibullets)))))

;;;; Tests
(check-expect (spaceship-is-hit? SPACESHIP-MID 
                                 (world-ibullets WORLD-INIT)) #false)
(check-expect (spaceship-is-hit? SPACESHIP-MID 
                                 (list POSN-50-300 POSN-BOTTOM-MID)) #true)

;;;; Signature
;; end-game?: World -> Boolean

;;;; Purpose
;; GIVEN: the current world
;; RETURNS: true if the spaceship is hit by any bullets from invaders,
;;          false otherwise

;;;; Examples
;; (end-game? WORLD-INIT) => #false
;; (end-game? WORLD-END)  => #true

;;;; Function Definition
(define (end-game? world)
  (or (spaceship-is-hit? (world-spaceship world) (world-ibullets world))
      (empty? (world-invaders world))))

;;;; Tests
(check-expect (end-game? WORLD-INIT) #false)
(check-expect (end-game? WORLD-END) #true)


(define POSN-BOTTOM-MID (make-posn (/ CANVAS-WIDTH 2) (- CANVAS-HEIGHT 20)))
(define BULLETS-SPACESHIP (cons POSN-BOTTOM-MID empty))
(define WORLD-INIT (make-world INVADERS-4-9 SPACESHIP-MID empty empty))
(define WORLD-END (make-world INVADERS-4-9 
                              (make-spaceship (make-posn 10 10) 'left)
                              (list (make-posn 0 0))
                              (list (make-posn 9 9))))

(big-bang WORLD-INIT
          (to-draw draw-world)
          (on-tick world-step 0.1)
          (on-key key-handler)
          (stop-when end-game?))
