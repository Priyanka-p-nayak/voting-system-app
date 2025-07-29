;; Voting System Contract
;; A simple voting system for creating and voting on proposals

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-already-voted (err u101))
(define-constant err-proposal-not-found (err u102))
(define-constant err-voting-closed (err u103))

;; Data maps and vars
(define-data-var proposal-count uint u0)
(define-map proposals
  { proposal-id: uint }
  { title: (string-ascii 50), description: (string-ascii 200), votes-for: uint, votes-against: uint, active: bool })
(define-map votes
  { proposal-id: uint, voter: principal }
  bool)

;; Create a new proposal
(define-public (create-proposal (title (string-ascii 50)) (description (string-ascii 200)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (let ((new-id (+ (var-get proposal-count) u1)))
      (map-set proposals
        { proposal-id: new-id }
        { title: title, description: description, votes-for: u0, votes-against: u0, active: true })
      (var-set proposal-count new-id)
      (ok new-id))))

;; Vote on a proposal
(define-public (vote (proposal-id uint) (vote-for bool))
  (begin
    (let ((proposal (unwrap! (map-get? proposals { proposal-id: proposal-id }) err-proposal-not-found)))
      (asserts! (get active proposal) err-voting-closed)
      (asserts! (is-none (map-get? votes { proposal-id: proposal-id, voter: tx-sender })) err-already-voted)
      (map-set votes { proposal-id: proposal-id, voter: tx-sender } true)
      (map-set proposals { proposal-id: proposal-id }
        (merge proposal
          (if vote-for
            { votes-for: (+ (get votes-for proposal) u1), votes-against: (get votes-against proposal) }
            { votes-for: (get votes-for proposal), votes-against: (+ (get votes-against proposal) u1) })))
      (ok true))))