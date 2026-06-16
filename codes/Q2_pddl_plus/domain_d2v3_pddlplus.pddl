(define (domain d2v3-domestic-mobile-manipulator-plus)
  (:requirements :adl :typing :numeric-fluents :continuous-effects)

  (:types
    location - object
    item - object
    cup ingredient - item
  )

  (:predicates
    ;; Navigation and movement mode.
    (robot-at ?l - location)
    (connected ?from ?to - location)
    (moving)
    (move-origin ?l - location)
    (move-destination ?l - location)

    ;; Manipulation state.
    (handempty)
    (holding ?i - item)
    (at ?i - item ?l - location)

    ;; Functional kitchen locations.
    (water-source ?l - location)
    (coffee-machine ?l - location)
    (serving-place ?l - location)

    ;; Coffee preparation states.
    (empty ?c - cup)
    (has-water ?c - cup)
    (has-coffee-powder ?c - cup)
    (brewed ?c - cup)
    (served ?c - cup)

    ;; Mission and temporal safety state.
    (mission-running)
    (mission-complete)
    (deadline-missed)
  )

  (:functions
    (elapsed-time)
    (deadline)
    (move-progress)
    (current-move-duration)
    (move-duration ?from ?to - location)
  )

  ;; The mission clock runs while the task is not finished.
  ;; This process makes late execution observable by the deadline event.
  (:process mission-clock
    :parameters ()
    :precondition (mission-running)
    :effect (increase (elapsed-time) (* #t 1))
  )

  ;; Movement is not instantaneous. When a start-move action is applied,
  ;; this process accumulates progress until the finish-move event fires.
  (:process movement-progress
    :parameters ()
    :precondition (moving)
    :effect (increase (move-progress) (* #t 1))
  )

  ;; The world automatically completes the movement when enough time has passed.
  (:event finish-move
    :parameters (?from ?to - location)
    :precondition (and
      (moving)
      (move-origin ?from)
      (move-destination ?to)
      (>= (move-progress) (current-move-duration))
    )
    :effect (and
      (robot-at ?to)
      (not (moving))
      (not (move-origin ?from))
      (not (move-destination ?to))
      (assign (move-progress) 0)
      (assign (current-move-duration) 0)
    )
  )

  ;; If the task is still running after the deadline, the world marks failure.
  ;; The event removes mission-running to avoid repeated firings.
  (:event deadline-violation
    :parameters ()
    :precondition (and
      (mission-running)
      (> (elapsed-time) (deadline))
    )
    :effect (and
      (deadline-missed)
      (not (mission-running))
    )
  )

  ;; Agent action: start a movement. The actual arrival is handled by a process/event pair.
  (:action start-move
    :parameters (?from ?to - location)
    :precondition (and
      (mission-running)
      (not (deadline-missed))
      (not (moving))
      (robot-at ?from)
      (connected ?from ?to)
    )
    :effect (and
      (not (robot-at ?from))
      (moving)
      (move-origin ?from)
      (move-destination ?to)
      (assign (move-progress) 0)
      (assign (current-move-duration) (move-duration ?from ?to))
    )
  )

  (:action pick-up
    :parameters (?i - item ?l - location)
    :precondition (and
      (mission-running)
      (not (deadline-missed))
      (not (moving))
      (robot-at ?l)
      (at ?i ?l)
      (handempty)
    )
    :effect (and
      (holding ?i)
      (not (at ?i ?l))
      (not (handempty))
    )
  )

  (:action put-down
    :parameters (?i - item ?l - location)
    :precondition (and
      (mission-running)
      (not (deadline-missed))
      (not (moving))
      (robot-at ?l)
      (holding ?i)
    )
    :effect (and
      (at ?i ?l)
      (handempty)
      (not (holding ?i))
    )
  )

  (:action fill-water
    :parameters (?c - cup ?l - location)
    :precondition (and
      (mission-running)
      (not (deadline-missed))
      (not (moving))
      (robot-at ?l)
      (water-source ?l)
      (holding ?c)
      (empty ?c)
    )
    :effect (and
      (has-water ?c)
      (not (empty ?c))
    )
  )

  (:action add-coffee-powder
    :parameters (?powder - ingredient ?c - cup ?l - location)
    :precondition (and
      (mission-running)
      (not (deadline-missed))
      (not (moving))
      (robot-at ?l)
      (holding ?powder)
      (at ?c ?l)
      (has-water ?c)
    )
    :effect (and
      (has-coffee-powder ?c)
    )
  )

  (:action brew-coffee
    :parameters (?c - cup ?l - location)
    :precondition (and
      (mission-running)
      (not (deadline-missed))
      (not (moving))
      (robot-at ?l)
      (coffee-machine ?l)
      (holding ?c)
      (has-water ?c)
      (has-coffee-powder ?c)
    )
    :effect (and
      (brewed ?c)
    )
  )

  (:action serve-coffee
    :parameters (?c - cup ?l - location)
    :precondition (and
      (mission-running)
      (not (deadline-missed))
      (not (moving))
      (robot-at ?l)
      (serving-place ?l)
      (holding ?c)
      (brewed ?c)
    )
    :effect (and
      (served ?c)
      (mission-complete)
      (not (mission-running))
    )
  )
)
