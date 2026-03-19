;; ---------------------------------------------------------
;; Action Pacing Harmonizer
;; Regulates action cadence toward a healthy rhythm
;; ---------------------------------------------------------

;; -----------------------------
;; Error codes
;; -----------------------------

(define-constant ERR-ACTION-TOO-FAST u300)
(define-constant ERR-ACTION-TOO-SLOW u301)

;; -----------------------------
;; Configuration constants
;; -----------------------------

(define-constant MIN-ACTION-GAP u72)     ;; ~12 hours
(define-constant IDEAL-ACTION-GAP u144)  ;; ~1 day
(define-constant MAX-ACTION-GAP u1008)   ;; ~1 week

(define-constant HARMONY-REWARD u1)
(define-constant HARMONY-PENALTY u1)

;; -----------------------------
;; Data storage
;; -----------------------------

;; Last action block
(define-map last-action-block
  principal
  uint
)

;; Pacing harmony score
(define-map pacing-score
  principal
  uint
)

;; -----------------------------
;; Read-only helpers
;; -----------------------------

(define-read-only (get-pacing-score (user principal))
  (default-to u0 (map-get? pacing-score user))
)

(define-read-only (get-last-action (user principal))
  (map-get? last-action-block user)
)

;; -----------------------------
;; Core logic
;; -----------------------------

(define-public (record-action)
  (let (
        (user tx-sender)
        (current-block u1)
        (last-action (map-get? last-action-block tx-sender))
       )

    ;; First action initializes state
    (if (is-none last-action)
        (begin
          (map-set last-action-block user current-block)
          (map-set pacing-score user u1)
          (ok u1)
        )

        ;; Returning user
        (let (
              (previous-block (unwrap-panic last-action))
              (gap (- current-block previous-block))
              (current-score (default-to u0 (map-get? pacing-score user)))
             )

          ;; Too fast -> hard reject (anti-spam)
          (if (< gap MIN-ACTION-GAP)
              (err ERR-ACTION-TOO-FAST)

              ;; Ideal pacing -> reward
              (if (<= gap IDEAL-ACTION-GAP)
                  (let ((new-score (+ current-score HARMONY-REWARD)))
                    (map-set pacing-score user new-score)
                    (map-set last-action-block user current-block)
                    (ok new-score)
                  )

                  ;; Too slow -> soft penalty
                  (if (> gap MAX-ACTION-GAP)
                      (let (
                            (penalized-score
                              (if (> current-score HARMONY-PENALTY)
                                  (- current-score HARMONY-PENALTY)
                                  u0
                              )
                            )
                           )
                        (map-set pacing-score user penalized-score)
                        (map-set last-action-block user current-block)
                        (ok penalized-score)
                      )

                      ;; Acceptable but imperfect pacing -> neutral pass
                      (begin
                        (map-set last-action-block user current-block)
                        (ok current-score)
                      )
                  )
              )
          )
        )
    )
  )
)
