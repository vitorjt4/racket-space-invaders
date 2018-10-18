; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname space-invader) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)

(define ZERO 0)
(define ONE 1)
(define TWO 2)
(define TEXT-SIZE 28)
(define SSHIP-MOVE-UNIT 10)
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
(define MAX-LIVES-MSHIP 1)
(define MAX-LIVES-SSHIP 3)
(define MIN-LIVES 0)
(define MIN-SCORE 0)
(define SCORE-HIT-INVDR 5)
(define TICK-0 0)
(define TICK-10 10)
(define TICK-3O 30)
(define TOP-LEFT (make-posn 20 20))
(define MSHIP-RECT (rectangle INVADER-LENGTH INVADER-LENGTH 'solid "purple"))
(define MSHIP-MOVE-LEN 20)
(define SCORE-HIT-MSHIP 20)

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
                        MAX-LIVES-SSHIP))
(define SPACESHIP-DEAD (make-spaceship 
                        (make-posn (/ CANVAS-WIDTH 2) (- CANVAS-HEIGHT 20))
                        SPACESHIP-DIR-INIT
                        0))
(define MSHIP-INIT (make-spaceship TOP-LEFT 'right 0))
(define MSHIP-DEAD (make-spaceship TOP-LEFT 'right 0))
(define MSHIP-APPEAR (make-spaceship TOP-LEFT 'right 1))

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
(define-struct world 
                [invaders spaceship sbullets ibullets score ticks mothership])

;; Constructor Template:
;; A World is a (make-world LoF<Invader> Spaceship LoF<SBullet> 
;;                          LoF<IBullet> Natural Natural Spaceship)
;; INTERP: invaders represents invaders in the game
;;         spaceship represents a spaceship in the game
;;         sbullets represents bullets from the spaceship in the game
;;         ibullets represents bullets from invaders in the game
;;         score represents the score of the current game
;;         ticks represents the ticks of the clock
;;         mothership represents a mothership in the game

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
(define SPACESHIP-300-10-left 
  (make-spaceship (make-posn 300 10) 'left MAX-LIVES-MSHIP))
(define WORLD-TEST-DRAW-MSHIP-INIT
  (make-world (list POSN-50-100) SPACESHIP-300-10-left 
              (list POSN-50-40) (list POSN-250-50) 
              MIN-SCORE TICK-0 MSHIP-INIT))
(define WORLD-TEST-DRAW-MSHIP-APPEAR
  (make-world (list POSN-50-100) SPACESHIP-300-10-left 
              (list POSN-50-40) (list POSN-250-50) 
              MIN-SCORE TICK-0 MSHIP-APPEAR))

;;;; Signature
;; first-x: Natural -> Real

;;;; Purpose
;; GIVEN: a natural number representing the number of columns
;; RETURNS: the appropriate x coordinate value for the first invader in a row

(define (first-x cols)
  (/ (- CANVAS-WIDTH (* (- cols ONE) TWO INVADER-LENGTH)) TWO))

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
    [(= cols ZERO)	empty]
    [else (cons 
           (make-posn x y) 
           (invader-cons-col 
            (+ x (* TWO INVADER-LENGTH)) y (- cols ONE)))]))

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
    [(= rows ZERO) empty]
    [else (append 
           (invader-cons-col 
            (first-x cols) y cols) 
           (invader-cons-row 
            (+ y INVADER-LENGTH GAP-BETWEEN-ROWS) 
            (- rows ONE)
            cols))]))

;;;; Tests
(check-expect (invader-cons-row 10 2 2) 
              (list (make-posn 200 10) (make-posn 250 10) 
                    (make-posn 200 45) (make-posn 250 45)))

;;;; Signature
;; draw-score: Natural Image -> Image

;;;; Purpose
;; GIVEN: a nutural number and an image
;; RETURNS: a new image with the score on the given image

(define TOP-CENTER (make-posn (/ CANVAS-WIDTH 2) 15))

(define (draw-score score img)
  (place-image
   (text (number->string score) TEXT-SIZE "black")
   (posn-x TOP-CENTER)
   (posn-y TOP-CENTER)
   img))

;;;; Tests
(check-expect (draw-score 10 BACKGROUND)
              (place-image (text "10" TEXT-SIZE "black")
                           (posn-x TOP-CENTER)
                           (posn-y TOP-CENTER)
                           BACKGROUND))


;;;; Signature
;;;; draw-lives: Spaceship Image -> Image

;;;; Purpose
;; GIVEN: a nutural number and an image
;; RETURNS: a new image with the score on the given image

(define BOTTOM-RIGHT-CORNER (make-posn (- CANVAS-WIDTH  30)
                                       (- CANVAS-HEIGHT 30)))
(define (draw-lives spaceship img)
  (place-image
   (text (number->string (spaceship-lives spaceship)) TEXT-SIZE "red")
   (posn-x BOTTOM-RIGHT-CORNER)
   (posn-y BOTTOM-RIGHT-CORNER)
   img))


;;;; Tests
(check-expect (draw-lives SPACESHIP-DEAD BACKGROUND)
              (place-image
               (text "0" TEXT-SIZE "red")
               (posn-x BOTTOM-RIGHT-CORNER)
               (posn-y BOTTOM-RIGHT-CORNER)
               BACKGROUND))


;;;; Signature
;; draw-lopsn: LoP Image Image -> Image

;;;; Purpose
;; GIVEN: a list of posns, a base image to be placed on
;;        and a shape image representing an item we are about to draw
;; RETURNS: an image with all items drawn on the base image

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
;; draw-mothership: Spaceship Image -> Image

;;;; Purpose
;; GIVEN: a mothership and an image
;; RETURNS: a new image with the mothership drawn on the given image

(define (draw-mothership mothership img)
  (place-image
   MSHIP-RECT
   (posn-x (spaceship-position mothership))
   (posn-y (spaceship-position mothership))
   img))

;;;; Tests
(check-expect (draw-mothership MSHIP-INIT BACKGROUND)
              (place-image
               MSHIP-RECT
               (posn-x TOP-LEFT)
               (posn-y TOP-LEFT)
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
        (draw-ibullets (world-ibullets world) 
          (draw-lives (world-spaceship world)
            (draw-score (world-score world)
              (if (= ZERO (spaceship-lives (world-mothership world)))
                  BACKGROUND
                  (draw-mothership (world-mothership world) 
                                    BACKGROUND)))))))))

;;;; Tests
(check-expect (draw-world WORLD-TEST-DRAW-MSHIP-INIT)
  (place-image INVADER-RECT 50 100
    (place-image SPACESHIP-RECT 300 10
      (place-image BULLET-RED 50 40
        (place-image BULLET-BLK 250 50 
          (place-image
           (text "1" 28 "red")
           (posn-x BOTTOM-RIGHT-CORNER)
           (posn-y BOTTOM-RIGHT-CORNER)
              (place-image
                (text "0" 28 "black")
                (posn-x TOP-CENTER)
                (posn-y TOP-CENTER)
                BACKGROUND)))))))

(check-expect (draw-world WORLD-TEST-DRAW-MSHIP-APPEAR)
  (place-image INVADER-RECT 50 100
    (place-image SPACESHIP-RECT 300 10
      (place-image BULLET-RED 50 40
        (place-image BULLET-BLK 250 50 
          (place-image
            (text "1" 28 "red")
            (posn-x BOTTOM-RIGHT-CORNER)
            (posn-y BOTTOM-RIGHT-CORNER)
              (place-image
                (text "0" 28 "black")
                (posn-x TOP-CENTER)
                (posn-y TOP-CENTER)
                  (place-image 
                   MSHIP-RECT
                  (posn-x TOP-LEFT)
                  (posn-y TOP-LEFT)
                   BACKGROUND))))))))
;;;; Signature
;; spaceship-reach-left-corner?: Spaceship -> Boolean

;;;; Purpose
;; GIVEN: a spaceship
;; RETURNS: true if the spaceship reaches the left corner, false otherwise

(define (spaceship-reach-left-corner? spaceship)
  (<= (- (posn-x (spaceship-position spaceship)) (/ SPACESHIP-L TWO)) ZERO))

;;;; Tests
(check-expect 
 (spaceship-reach-left-corner? 
  (make-spaceship (make-posn 15 200) 'left MAX-LIVES-MSHIP)) #true)
(check-expect 
 (spaceship-reach-left-corner? 
  (make-spaceship (make-posn (+ 15 1) 200) 'left MAX-LIVES-MSHIP)) #false)

;;;; Signature
;; spaceship-reach-right-corner?: Spaceship -> Boolean

;;;; Purpose
;; GIVEN: a spaceship
;; RETURNS: true if the spaceship reaches the right corner, false otherwise

(define (spaceship-reach-right-corner? spaceship)
  (>= (+ (posn-x (spaceship-position spaceship)) (/ SPACESHIP-L TWO)) 
      CANVAS-WIDTH))

;;;; Tests
(check-expect 
 (spaceship-reach-right-corner? 
  (make-spaceship (make-posn (- 450 15) 200) 'left MAX-LIVES-MSHIP)) #true)
(check-expect 
 (spaceship-reach-right-corner? 
  (make-spaceship (make-posn (- 450 15 1) 200) 'left MAX-LIVES-MSHIP)) #false)


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
  (make-spaceship (make-posn 15 200) 'left MAX-LIVES-MSHIP)) #true)
(check-expect 
 (spaceship-reach-corner? 
  (make-spaceship (make-posn (+ 15 1) 200) 'left MAX-LIVES-MSHIP)) #false)
(check-expect 
 (spaceship-reach-corner? 
  (make-spaceship (make-posn (- 450 15) 200) 'left MAX-LIVES-MSHIP)) #true)
(check-expect 
 (spaceship-reach-corner? 
  (make-spaceship (make-posn (- 450 15 1) 200) 'left MAX-LIVES-MSHIP)) #false)


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
      (make-posn (- (posn-x (spaceship-position spaceship)) SSHIP-MOVE-UNIT)
                 (posn-y (spaceship-position spaceship)))
      'left
      (spaceship-lives spaceship))]
    [(symbol=? (spaceship-direction spaceship) 'right)
     (make-spaceship
      (make-posn (+ (posn-x (spaceship-position spaceship)) SSHIP-MOVE-UNIT)
                 (posn-y (spaceship-position spaceship)))
      'right
      (spaceship-lives spaceship))]))

;;;; Tests
(check-expect (move-spaceship
               (make-spaceship (make-posn 15 200) 'left MAX-LIVES-MSHIP))
              (make-spaceship (make-posn 15 200) 'left MAX-LIVES-MSHIP))
(check-expect (move-spaceship
               (make-spaceship (make-posn 25 200) 'left MAX-LIVES-MSHIP))
              (make-spaceship (make-posn 15 200) 'left MAX-LIVES-MSHIP))
(check-expect (move-spaceship
               (make-spaceship 
                (make-posn (- 450 15) 200) 'right MAX-LIVES-MSHIP))
              (make-spaceship 
                (make-posn (- 450 15) 200) 'right MAX-LIVES-MSHIP))
(check-expect (move-spaceship
               (make-spaceship 
                (make-posn (- 450 25) 200) 'right MAX-LIVES-MSHIP))
              (make-spaceship 
                (make-posn (- 450 15) 200) 'right MAX-LIVES-MSHIP))


;;;; Signature
;; mothership-stepper: World -> Spaceship

;;;; Purpose
;; GIVEN: the current world
;; RETURNS: the mothership after 1 tick
;;          - if the mothership is hit or goes out of bounds,
;;            it reappears (is reinitialized with 1 life) after 30 ticks
;;          - otherwise, it just moves one step to the right

(define (mothership-stepper world)
  (local ((define mothership (world-mothership world))
          (define ticks (world-ticks world))
          (define posn-init (spaceship-position MSHIP-INIT)))
    (if (or (= (spaceship-lives mothership) ZERO)  ;; mothership is hit or 
            (mothership-out-of-bounds? mothership))  ;; is out of bounds
        (if (and (= (modulo ticks TICK-3O) ZERO)
                 (>= ticks TICK-3O))
            MSHIP-APPEAR                    ;; reappears after 30 ticks
            MSHIP-DEAD)                     ;; remains dead
        (make-spaceship       ;; if not hit, move one step to the right
         (make-posn
          (+ MSHIP-MOVE-LEN (posn-x (spaceship-position mothership)))
          (posn-y posn-init)) 'right ONE))))

;;;; Tests
(check-expect 
 (mothership-stepper ;; at 60 ticks, mothership dead -> alive
  (make-world (list POSN-50-100) SPACESHIP-300-10-left 
              (list POSN-50-40) (list POSN-250-50) MIN-SCORE 60 MSHIP-DEAD))
 MSHIP-APPEAR)
(check-expect 
 (mothership-stepper  ;; at 59 ticks, mothership dead
  (make-world (list POSN-50-100) SPACESHIP-300-10-left 
              (list POSN-50-40) (list POSN-250-50) MIN-SCORE 59 MSHIP-DEAD))
 MSHIP-DEAD)
(check-expect 
 (mothership-stepper ;; at 60 ticks, out-of-bound mothership reappears
  (make-world (list POSN-50-100) SPACESHIP-300-10-left
              (list POSN-50-40) (list POSN-250-50) MIN-SCORE 60 MSHIP-OUT))
 MSHIP-APPEAR)
(check-expect 
 (mothership-stepper ;; at 60 ticks, out-of-bound mothership reappears
  (make-world (list POSN-50-100) SPACESHIP-300-10-left
              (list POSN-50-40) (list POSN-250-50) MIN-SCORE 30 MSHIP-IN))
 MSHIP-OUT)



;;;; Signature
;; spaceship-step: World Boolean -> Spaceship

;;;; Purpose
;; GIVEN: the current world and a boolean
;;        representing if the mothership is hit by the spaceship
;; RETURNS: 1. a new spaceship after moving one unit to its direction 
;;             if it is not hit and does not hit mothership
;;          2. or a moved spaceship with 1 less life if it is hit
;;          3. or a moved spaceship with 1 more life it it hits the mothership

(define (spaceship-step world mothership-is-hit)
  (local ((define spaceship-orig (world-spaceship world))
          (define moved-spaceship (move-spaceship spaceship-orig)))
    (if (spaceship-is-hit? spaceship-orig (world-ibullets world))
        (make-spaceship  ;; if hit, re-init the spaceship with a life less
         (spaceship-position  SPACESHIP-INIT)
         (spaceship-direction SPACESHIP-INIT)
         (- (spaceship-lives spaceship-orig) ONE))
        (if (not mothership-is-hit)
            moved-spaceship
            (make-spaceship
             (spaceship-position moved-spaceship)
             (spaceship-direction moved-spaceship)
             (+ (spaceship-lives spaceship-orig) ONE))))))

;;;; Tests
(check-expect ;; case 1: spaceship, mothership not hit
 (spaceship-step
  (make-world (list POSN-1)  ;; invaders
              (make-spaceship (make-posn 50 0) 'right MAX-LIVES-SSHIP)
              (list POSN-2)  ;; sbulltes
              (list POSN-3)  ;; ibullets
              MIN-SCORE TICK-0 
              (make-spaceship POSN-4 'right MAX-LIVES-MSHIP))
  #f)
 (make-spaceship (make-posn (+ 50 SSHIP-MOVE-UNIT) 0) 'right MAX-LIVES-SSHIP))

(check-expect ;; case 2: spaceship hit
 (spaceship-step
  (make-world (list POSN-1)  ;; invaders
              (make-spaceship (make-posn 50 0) 'right MAX-LIVES-SSHIP)
              (list POSN-2)  ;; sbulltes
              (list (make-posn 50 0))  ;; ibullets
              MIN-SCORE TICK-0 
              (make-spaceship POSN-4 'right MAX-LIVES-MSHIP))
  #f)
 (make-spaceship (spaceship-position SPACESHIP-INIT)
                 (spaceship-direction SPACESHIP-INIT)
                 (- MAX-LIVES-SSHIP 1)))

(check-expect ;; case 3: mothership hit
 (spaceship-step
  (make-world (list POSN-1)  ;; invaders
              (make-spaceship (make-posn 50 0) 'right MAX-LIVES-SSHIP)
              (list POSN-2)  ;; sbulltes
              (list (make-posn 100 0))  ;; ibullets
              MIN-SCORE TICK-0 
              (make-spaceship POSN-2 'right MAX-LIVES-MSHIP))
  #t)
 (make-spaceship 
  (make-posn (+ 50 SSHIP-MOVE-UNIT) 0) 'right (+ 1 MAX-LIVES-SSHIP)))

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
                          (- (posn-y sbullet) SSHIP-MOVE-UNIT))))
       (map move-sbullet sbullets))]))

;;;; Tests
(check-expect (move-sbullets
               (list (make-posn 25 200) (make-posn 25 190)))
              (list (make-posn 25 190) (make-posn 25 180)))
(check-expect (move-sbullets empty) empty)


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
                          (+ (posn-y ibullet) SSHIP-MOVE-UNIT))))
       (map move-ibullet ibullets))]))

;;;; Tests
(check-expect (move-ibullets empty) empty)
(check-expect (move-ibullets
               (list (make-posn 25 200) (make-posn 25 190)))
              (list (make-posn 25 210) (make-posn 25 200)))


;;;; Purpose
;; GIVEN: a list of invaders
;; RETURNS: a new list of invaders in the new positions after
;;          they move down the amount of units as their length

;;;; move-invaders: LoF<Invader> -> LoF<Invader>

(define (move-invaders invaders)
  (if (empty? invaders)
      empty
      (map
       ;;;; Invader -> Invader
       (lambda (i) 
         (make-posn (posn-x i)
                    (+ (posn-y i) INVADER-LENGTH)))
       invaders)))

;;;; Tests
(check-expect (move-invaders empty) empty)
(check-expect (move-invaders 
               (list (make-posn 10 10)
                     (make-posn 20 10)))
              (list (make-posn 10 (+ INVADER-LENGTH 10))
                    (make-posn 20 (+ INVADER-LENGTH 10))))

;;;; Signature
;; invaders-step: World -> LoF<Invader>

;;;; Purpose
;; GIVEN: the current world
;; RETURNS: a new list of invaders,
;;          and the invaders only move down every 10 ticks

(define (invaders-step world)
  (local ((define ticks (world-ticks world))
          (define invaders (world-invaders world)))
    (if (and (not (= TICK-0 ticks))
             (= ZERO (modulo ticks TICK-10)))
        (move-invaders invaders)
        invaders)))

;;;; Tests
(check-expect ;; should not move yet
 (invaders-step
  (make-world (list (make-posn 10 10) (make-posn 20 10)) ;; invaders
              SPACESHIP-INIT 
              empty ;; sbulltes
              empty  ;; ibullets
              MIN-SCORE
              TICK-0 
              MSHIP-INIT))
 (list (make-posn 10 10) (make-posn 20 10)))

(check-expect ;; should move
 (invaders-step
  (make-world (list (make-posn 10 10) (make-posn 20 10)) ;; invaders
              SPACESHIP-INIT 
              empty ;; sbulltes
              empty  ;; ibullets
              MIN-SCORE
              (+ 10 TICK-0)
              MSHIP-INIT))
 (list (make-posn 10 (+ 10 INVADER-LENGTH))
       (make-posn 20 (+ 10 INVADER-LENGTH))))


;;;; Signature
;; key-handler: World Key-Event -> World

;;;; Purpose
;; GIVEN: the current world and a key event
;; RETURNS: a new world with spaceship or its bullets updated
;;          according to the key event

(define INVADERS-4-9 (invader-cons-row (* 4 GAP-BETWEEN-ROWS) 
                                       ROW-NUM-INVADER COL-NUM-INVADER))
(define WORLD-TEST-KH-1-BFR 
  (make-world INVADERS-4-9 ;; spaceship reach right corner
              (make-spaceship 
                (make-posn (- 450 15) 200) 'left MAX-LIVES-MSHIP)
              (list (make-posn 0 0))
              (list (make-posn 9 9)) MIN-SCORE TICK-0 MSHIP-INIT))
(define WORLD-TEST-KH-1-AFT 
  (make-world INVADERS-4-9 
              (make-spaceship 
                (make-posn (- 450 15 10) 200) 'left MAX-LIVES-MSHIP)
              (list (make-posn 0 0))
              (list (make-posn 9 9)) MIN-SCORE TICK-0 MSHIP-INIT))
(define WORLD-TEST-KH-2-BFR 
  (make-world INVADERS-4-9 ;; spaceship reach left corner
              (make-spaceship (make-posn 15 200) 'left MAX-LIVES-MSHIP)
              (list (make-posn 0 0))
              (list (make-posn 9 9)) MIN-SCORE TICK-0 MSHIP-INIT))
(define WORLD-TEST-KH-2-AFT 
  (make-world INVADERS-4-9 
              (make-spaceship 
                (make-posn (+ 15 10) 200) 'right MAX-LIVES-MSHIP)
              (list (make-posn 0 0))
              (list (make-posn 9 9)) MIN-SCORE TICK-0 MSHIP-INIT))

(define WORLD-TEST-KH-3-BFR 
  (make-world INVADERS-4-9
              (make-spaceship 
                (make-posn (- 450 10) 200) 'left MAX-LIVES-MSHIP)
              (list (make-posn 0 0))
              (list (make-posn 9 9)) MIN-SCORE TICK-0 MSHIP-INIT))
(define WORLD-TEST-KH-3-AFT 
  (make-world INVADERS-4-9 
              (make-spaceship 
                (make-posn (- 450 10) 200) 'right MAX-LIVES-MSHIP)
              (list (make-posn 0 0))
              (list (make-posn 9 9)) MIN-SCORE TICK-0 MSHIP-INIT))
(define WORLD-TEST-KH-4-BFR 
  (make-world INVADERS-4-9 
              (make-spaceship (make-posn 0 0) 'right MAX-LIVES-MSHIP)
              empty
              empty MIN-SCORE TICK-0 MSHIP-INIT))
(define WORLD-TEST-KH-4-AFT 
  (make-world INVADERS-4-9 
              (make-spaceship (make-posn 0 0) 'right MAX-LIVES-MSHIP)
              (list (make-posn 0 0))
              empty MIN-SCORE TICK-0 MSHIP-INIT))


;;;; Function Definition
(define (key-handler world ke)
  (cond 
    [(and (spaceship-reach-left-corner? (world-spaceship world))
          (key=? ke "right"))
     (make-world (world-invaders world)
       (make-spaceship
        (make-posn (+ 
                    (posn-x (spaceship-position 
                             (world-spaceship world))) SSHIP-MOVE-UNIT)
                    (posn-y (spaceship-position 
                            (world-spaceship world))))
        'right
        (spaceship-lives (world-spaceship world)))
       (world-sbullets world)
       (world-ibullets world)
       (world-score world)
       (world-ticks world)
       (world-mothership world))]
    [(and (spaceship-reach-right-corner? (world-spaceship world))
          (key=? ke "left"))
     (make-world (world-invaders world)
       (make-spaceship
        (make-posn (- 
                    (posn-x (spaceship-position 
                            (world-spaceship world))) SSHIP-MOVE-UNIT)
                    (posn-y (spaceship-position 
                            (world-spaceship world))))
        'left
        (spaceship-lives (world-spaceship world)))
       (world-sbullets world)
       (world-ibullets world)
       (world-score world)
       (world-ticks world)
       (world-mothership world))]
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
       (world-ticks world)
       (world-mothership world))]
    [(and (key=? ke " ") 
          (< (length (world-sbullets world)) BULLET-MAX-SPACESHIP))
     (make-world (world-invaders world)
       (world-spaceship world)
       (cons (spaceship-position (world-spaceship world))
             (world-sbullets world))
       (world-ibullets world)
       (world-score world)
       (world-ticks world)
       (world-mothership world))]
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
;;   1. If any of the spaceship or invader bullets, 
;;      or mothership go out of bounds,
;;      they will be removed from the canvas.
;;   2. If a spaceship bullet hits an invader, 
;;      it needs to be removed from the canvas.
;;   3. If an invader bullet hits the spaceship, 
;;      it needs to be removed from the canvas.
;;   4. Any of the invaders that are hit by the spaceship
;;      bullets will be removed from the canvas
;;   5. For all other spaceship and invader bullets, 
;;      and spaceship or mothership if not hit
;;      they just move to the next world-step position.
;;   6. the score will be updated if the spaceship bullets 
;;      hit any of the invaders, it will be further updated 
;;      if any of the bullets also hits the mothership
;;   7. the tick increases by 1 in each world step
;;   8. new invader bullets could be generated if there are enough invaders
;;      and the bullets have not reached the maximum amount
;;   9. the mothership will reappear in every 30 ticks if it has disappeared
;;      either because it was hit or it has moved out of bounds
;;   10. the invaders will all move down the amount of units as their length
;;       every 10 ticks


;;;; Function Definition
(define (world-step world)
  (local ((define invaders
            (invaders-step world))
          (define remove-lst 
            (filter-sbullets-and-invaders-to-be-removed 
             world))
          (define sbullets
            (move-sbullets
             (remove-sbullets-or-invaders-after-hit
              (world-sbullets world)
              remove-lst)))
          (define mothership-is-hit
            (mothership-is-hit? sbullets (world-mothership world)))
          (define spaceship
            (spaceship-step world mothership-is-hit))
          (define invaders-updated
            (remove-sbullets-or-invaders-after-hit
             invaders
             remove-lst)))
    
    (remove-bullets-out-of-bounds-world
     (make-world invaders-updated
                 spaceship
                 sbullets
                 (move-ibullets
                  (remove-ibullet-after-hit
                   spaceship
                   (invaders-fire 
                    (random (length invaders))
                    (world-ibullets world)
                    invaders)))
                 (update-score (world-score world)
                               invaders
                               invaders-updated
                               mothership-is-hit)
                 (+ ONE (world-ticks world))
                 (mothership-step world mothership-is-hit)))))

;;;; Tests
(check-expect 
 (world-step
  (make-world 
   (list (make-posn 10 10))
   (make-spaceship (make-posn 50 0) 'right MAX-LIVES-SSHIP)
   empty
   empty MIN-SCORE TICK-0 
   (make-spaceship TOP-LEFT 'right MAX-LIVES-MSHIP)))
 (make-world 
  (list (make-posn 10 10))
  (make-spaceship (make-posn (+ 50 SSHIP-MOVE-UNIT) 0) 'right MAX-LIVES-SSHIP)
  empty
  empty MIN-SCORE (+ 1 TICK-0)
  (make-spaceship 
   (make-posn (+ (posn-x TOP-LEFT) MSHIP-MOVE-LEN)
              (posn-y TOP-LEFT))
   'right MAX-LIVES-MSHIP)))

;;;; Signature
;; update-score: Score LoF<Invader> LoF<Invader> Boolean -> Score

;;;; Purpose
;; GIVEN: a score, an original list of invaders, an updated list of invaders
;;        and a boolean representing if the mothership is hit by the spaceship
;; RETURNS: 1. if the mothership is not hit, return an updated score
;;             calculated by checking how many invaders are destroyed
;;          2. otherwise, further update the score

(define (update-score old-score invaders-old invaders-new mothership-is-hit)
  (local ((define invaders-hit-num
            (- (length invaders-old)
               (length invaders-new)))
          (define new-score
            (+ old-score (* SCORE-HIT-INVDR invaders-hit-num))))
    (if (not mothership-is-hit) 
        new-score
        (+ SCORE-HIT-MSHIP new-score))))

;;;; Tests
(check-expect 
 (update-score 
  0
  (list (list 0 0) (list 10 0))
  (list (list 0 0) (list 10 0))
  #f)   
 0)

(check-expect 
 (update-score 
  0
  (list (list 0 0) (list 10 0))
  (list (list 10 0))
  #f)   
 (+ 0 (* 1 SCORE-HIT-INVDR)))

(check-expect 
 (update-score 
  0
  (list (list 0 0) (list 10 0))
  (list (list 10 0))
  #t)   
 (+ 0 (* 1 SCORE-HIT-INVDR) SCORE-HIT-MSHIP))

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
;; sbullet-hits-invader? Posn Posn -> Boolean
(define (sbullet-hits-invader? sbullet invader)
  (and
   (< (- (posn-y sbullet)  BULLET-RADIUS)
      (+ (posn-y invader) (/ INVADER-LENGTH TWO)))
   (> (+ (posn-x sbullet)  BULLET-RADIUS)
      (- (posn-x invader) (/ INVADER-LENGTH TWO)))
   (< (- (posn-x sbullet)  BULLET-RADIUS)
      (+ (posn-x invader) (/ INVADER-LENGTH TWO)))))

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
     (sbullet-hits-invader? sbullet invader))
   invaders))

;;;; Tests
(check-expect (sbullet-hits-invaders? BULLET-250-65 INVADERS-1) #true)
(check-expect (sbullet-hits-invaders? BULLET-250-66 INVADERS-1) #false)
(check-expect (sbullet-hits-invaders? BULLET-265-65 INVADERS-1) #true)
(check-expect (sbullet-hits-invaders? BULLET-266-65 INVADERS-1) #false)

;;;; Signature
;; invader-is-hit?: LoF<SBullet> Invader -> Boolean

;;;; Purpose
;; GIVEN: a list of spaceship bullets and an invader
;; RETURNS: true if the invader is hit by any of the bullets,
;;          false otherwise

(define (invader-is-hit? sbullets invader)
  (ormap 
   ;;;; Posn -> Boolean
   (lambda (sbullet)
     (sbullet-hits-invader? sbullet invader))
   sbullets))


;;;; Signature
;; mothership-is-hit?: LoF<SBullet> Spaceship -> Boolean

;;;; Purpose
;; GIVEN: a list of spaceship bullets and an mothership
;; RETURNS: true if the mothership is hit by any of the bullets,
;;          false otherwise

(define (mothership-is-hit? sbullets mothership)
  (ormap
   ;;;; SBullet -> Boolean
   (lambda (sb) (sbullet-hits-invader? sb (spaceship-position mothership)))
   sbullets))

;;;; Tests
(check-expect (mothership-is-hit?
               (list (make-posn 65 37) TOP-LEFT)
               (make-spaceship TOP-LEFT 'right 0)) #t)

(check-expect (mothership-is-hit?
               (list (make-posn 65 37) TOP-LEFT)
               (make-spaceship TOP-CENTER 'right 0)) #f)


;;;; Signature
;; mothership-step: World Boolean -> Spaceship

;;;; Purpose
;; GIVEN: the current world and a boolean
;;        representing if the mothership is hit by the spaceship
;; RETURNS: an initialized mothership if the boolean is true
;;          otherwise, return a new mothership in the next world step

(define (mothership-step world mothership-is-hit)
  (if mothership-is-hit
      MSHIP-INIT
      (mothership-stepper world)))

;;;; Tests
(check-expect 
 (mothership-step
  (make-world 
   (list (make-posn 10 10))
   (make-spaceship (make-posn 50 0) 'right MAX-LIVES-SSHIP)
   (list TOP-LEFT)
   empty MIN-SCORE TICK-0
   (make-spaceship TOP-LEFT 'right MAX-LIVES-MSHIP)) #t)
 MSHIP-INIT)
; test for another case is reflected in
; mothership-stepper and world-step


;;;; Data Definition
;; A BulletsOrInvaders is a LoF<Posn>
;; INTERP: represents a list containing bullets or (and) invaders

;;;; Signature
;; filter-sbullets-and-invaders-to-be-removed: World -> LoF<Posn>

;;;; Purpose
;; GIVEN: a list of spaceship bullets and a list of invaders
;; RETURNS: a single list containing spaceship bullets and invaders
;;          to be removed

(define (filter-sbullets-and-invaders-to-be-removed world)
  (local ((define sbullets (world-sbullets world))
          (define invaders (world-invaders world))
          (define mothership (world-mothership world)))
    (append
     ;;;; Posn -> Boolean
     (filter 
      (lambda (sb) 
        (or
         (sbullet-hits-invaders? sb invaders)
         (sbullet-hits-invader? sb (spaceship-position mothership)))) 
        sbullets)
     (filter (lambda (i) (invader-is-hit? sbullets i)) invaders))))

(define WORLD-TEST-FILTER 
  (make-world (list POSN-1 POSN-3 POSN-4)  ;; invaders
              (make-spaceship (make-posn 0 0) 'left MAX-LIVES-MSHIP)
              (list POSN-4 POSN-3 POSN-2)  ;; sbulltes
              (list (make-posn 0 0)) MIN-SCORE TICK-0 
              (make-spaceship POSN-2 'left MAX-LIVES-MSHIP)))

(define LoPSN-3 (list POSN-1 POSN-2 POSN-3 POSN-4))
(define LoPSN-4 (list POSN-2 POSN-3 POSN-4 POSN-5))
(define LoPSN-5 (list POSN-2 POSN-3 POSN-4 POSN-2 POSN-3 POSN-4))

;;;; Tests
(check-expect (filter-sbullets-and-invaders-to-be-removed WORLD-TEST-FILTER)
              (list POSN-4 POSN-3 POSN-2 POSN-3 POSN-4))

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
;; remove-sbullets-or-invaders-after-hit: 
;;    BulletsOrInvaders BulletsOrInvaders -> BulletsOrInvaders

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
(check-expect (remove-sbullets-or-invaders-after-hit 
               (list POSN-4 POSN-3 POSN-2) 
               (list POSN-4 POSN-3 POSN-2 POSN-3 POSN-4)) 
              empty)

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
  (or (<= (+ (posn-y bullet) BULLET-RADIUS) ZERO)
      (>= (- (posn-y bullet) BULLET-RADIUS) CANVAS-HEIGHT)))

;;;; Tests
(check-expect (bullet-out-of-bounds? BULLET-10-UP-IN) #false)
(check-expect (bullet-out-of-bounds? BULLET-10-UP-OUT) #true)
(check-expect (bullet-out-of-bounds? BULLET-10-LO-IN) #false)
(check-expect (bullet-out-of-bounds? BULLET-10-LO-OUT) #true)


;;;; Signature
;; mothership-out-of-bounds?: Spaceship -> Boolean

;;;; Purpose
;; GIVEN: a mothership
;; RETURNS: if the mothership has moved out of bounds

(define (mothership-out-of-bounds? mothership)
  (>= (+ (posn-x (spaceship-position mothership))
         (/ INVADER-LENGTH TWO)) CANVAS-WIDTH))

;;;; Tests
(define MSHIP-IN (make-spaceship 
                  (make-posn
                   (- CANVAS-WIDTH (/ INVADER-LENGTH 2) MSHIP-MOVE-LEN) 20) 
                   'right MAX-LIVES-MSHIP))
(define MSHIP-OUT (make-spaceship 
                   (make-posn
                    (- CANVAS-WIDTH (/ INVADER-LENGTH 2)) 20) 
                   'right MAX-LIVES-MSHIP))
(check-expect (mothership-out-of-bounds? MSHIP-IN) #f)
(check-expect (mothership-out-of-bounds? MSHIP-OUT) #t)

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
                        (make-spaceship POSN-2 'left MAX-LIVES-MSHIP) 
                        BULLETS-BFR BULLETS-BFR MIN-SCORE TICK-0 MSHIP-INIT))
(define WORLD-TEST-AFT (make-world empty 
                        (make-spaceship POSN-2 'left MAX-LIVES-MSHIP) 
                        BULLETS-AFT BULLETS-AFT MIN-SCORE TICK-0 MSHIP-INIT))

(define (remove-bullets-out-of-bounds-world world)
  (make-world
   (world-invaders world)
   (world-spaceship world)
   (remove-bullets-out-of-bounds (world-sbullets world))
   (remove-bullets-out-of-bounds (world-ibullets world))
   (world-score world)
   (world-ticks world)
   (world-mothership world)))

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
    [(= ZERO index) (first invaders)]
    [else (invader-at (rest invaders) (- index ONE))]))

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
      (< amount ONE)) ibullets]
    [else
     (cons
      (invader-at invaders (random (length invaders)))
      (invaders-fire
       (- amount ONE)
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
      (- (posn-x (spaceship-position spaceship)) (/ SPACESHIP-L TWO)))
   (< (- (posn-x bullet) BULLET-RADIUS) 
      (+ (posn-x (spaceship-position spaceship)) (/ SPACESHIP-L TWO)))
   (> (+ (posn-y bullet) BULLET-RADIUS) 
      (- (posn-y (spaceship-position spaceship)) (/ SPACESHIP-W TWO)))))

;;;; Tests
(check-expect (bullet-hits-spaceship? SPACESHIP-INIT POSN-BOTTOM-MID) #true)
(check-expect (bullet-hits-spaceship? SPACESHIP-INIT 
                                      (make-posn 400 490)) #false)

;;;; Signature
;; remove-ibullet-after-hit: Spaceship LoF<IBullet> -> LoF<IBullet>

;;;; Purpose
;; GIVEN: a spaceship and a list of invader bullets
;; RETURNS: a new list of invader bullets 
;;          with the ones hitting the spaceship removed

(define (remove-ibullet-after-hit spaceship ibullets)
  (filter (lambda (i) (not (bullet-hits-spaceship? spaceship i))) ibullets))

;;;; Tests
(check-expect (remove-ibullet-after-hit
               SPACESHIP-300-10-left
               (list (make-posn 300 10) (make-posn 10 10)))
              (list (make-posn 10 10)))
(check-expect (remove-ibullet-after-hit
               SPACESHIP-300-10-left
               (list (make-posn 400 10) (make-posn 10 10)))
              (list (make-posn 400 10) (make-posn 10 10)))

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

;;;; invaders-reach-btm?: LoF<Invader> -> Boolean

(define (invaders-reach-btm? invaders)
  (ormap 
   ;;;; Invader -> Boolean
   (lambda (i)
     (>= (posn-y i) BTM-OF-FIELD)) 
   invaders))

;;;; Signature
;; end-game?: World -> Boolean

;;;; Purpose
;; GIVEN: the current world
;; RETURNS: true if the spaceship is hit by any bullets from invaders,
;;          false otherwise

(define BTM-OF-FIELD (+ (posn-y (spaceship-position SPACESHIP-INIT))
                        (/ SPACESHIP-W 2)))

(define (end-game? world)
  (or (= (spaceship-lives (world-spaceship world)) ZERO)
      (invaders-reach-btm? (world-invaders world))))

;;;; Tests
(check-expect (end-game? WORLD-INIT) #false)
(check-expect (end-game? WORLD-END) #true)


(define POSN-BOTTOM-MID (make-posn (/ CANVAS-WIDTH 2) (- CANVAS-HEIGHT 20)))
(define BULLETS-SPACESHIP (cons POSN-BOTTOM-MID empty))
(define WORLD-INIT 
  (make-world INVADERS-4-9 SPACESHIP-INIT 
    empty empty MIN-SCORE TICK-0 MSHIP-INIT))
(define WORLD-END 
  (make-world INVADERS-4-9 SPACESHIP-DEAD 
    empty empty MIN-SCORE TICK-0 MSHIP-INIT))

(big-bang WORLD-INIT
          (to-draw draw-world)
          (on-tick world-step 0.1)
          (on-key key-handler)
          (stop-when end-game?))
