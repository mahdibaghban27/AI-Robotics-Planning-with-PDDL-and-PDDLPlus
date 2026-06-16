(define (domain d2v3-domestic-mobile-manipulator)
  (:requirements :strips :typing)

(:types
  location - object
  item - object
  cup ingredient - item
)

  (:predicates
    ;; Navigation state
    (robot-at ?l - location)
    (connected ?from ?to - location)

    ;; Manipulation state
    (handempty)
    (holding ?i - item)
    (at ?i - item ?l - location)

    ;; Functional kitchen locations
    (water-source ?l - location)
    (coffee-machine ?l - location)
    (serving-place ?l - location)

    ;; Coffee preparation states
    (empty ?c - cup)
    (has-water ?c - cup)
    (has-coffee-powder ?c - cup)
    (brewed ?c - cup)
    (served ?c - cup)
  )

  ;; Navigation action: changes only the robot position.
  (:action move
    :parameters (?from ?to - location)
    :precondition (and
      (robot-at ?from)
      (connected ?from ?to)
    )
    :effect (and
      (not (robot-at ?from))
      (robot-at ?to)
    )
  )

  ;; Manipulation action: the robot can pick an item only if both are at the same location.
  (:action pick-up
    :parameters (?i - item ?l - location)
    :precondition (and
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

  ;; Manipulation action: placing an item makes it available at the current robot location.
  (:action put-down
    :parameters (?i - item ?l - location)
    :precondition (and
      (robot-at ?l)
      (holding ?i)
    )
    :effect (and
      (at ?i ?l)
      (handempty)
      (not (holding ?i))
    )
  )

  ;; Manipulation/preparation action: the cup must be held at a water source.
  (:action fill-water
    :parameters (?c - cup ?l - location)
    :precondition (and
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

  ;; Manipulation/preparation action: powder is held, while the cup is located at the same place.
  (:action add-coffee-powder
    :parameters (?powder - ingredient ?c - cup ?l - location)
    :precondition (and
      (robot-at ?l)
      (holding ?powder)
      (at ?c ?l)
      (has-water ?c)
    )
    :effect (and
      (has-coffee-powder ?c)
    )
  )

  ;; Manipulation/preparation action: the cup must be carried to a coffee machine.
  (:action brew-coffee
    :parameters (?c - cup ?l - location)
    :precondition (and
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

  ;; Final manipulation action: a brewed cup is served at a serving place.
  (:action serve-coffee
    :parameters (?c - cup ?l - location)
    :precondition (and
      (robot-at ?l)
      (serving-place ?l)
      (holding ?c)
      (brewed ?c)
    )
    :effect (and
      (served ?c)
    )
  )
)
