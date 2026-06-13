(define (problem d2v3-plus-complex-deadline)
  (:domain d2v3-domestic-mobile-manipulator-plus)

  (:objects
    hallway cupboard sink pantry machine table - location
    cup1 - cup
    coffee-powder - ingredient
  )

  (:init
    ;; Distributed kitchen topology with a useful direct connection from pantry to machine.
    (connected hallway cupboard)
    (connected cupboard hallway)
    (connected hallway sink)
    (connected sink hallway)
    (connected hallway pantry)
    (connected pantry hallway)
    (connected hallway machine)
    (connected machine hallway)
    (connected pantry machine)
    (connected machine pantry)
    (connected machine table)
    (connected table machine)

    ;; Movement durations in time units.
    (= (move-duration hallway cupboard) 2)
    (= (move-duration cupboard hallway) 2)
    (= (move-duration hallway sink) 3)
    (= (move-duration sink hallway) 3)
    (= (move-duration hallway pantry) 2)
    (= (move-duration pantry hallway) 2)
    (= (move-duration hallway machine) 4)
    (= (move-duration machine hallway) 4)
    (= (move-duration pantry machine) 3)
    (= (move-duration machine pantry) 3)
    (= (move-duration machine table) 2)
    (= (move-duration table machine) 2)

    ;; Functional locations.
    (water-source sink)
    (coffee-machine machine)
    (serving-place table)

    ;; Initial symbolic state.
    (robot-at hallway)
    (handempty)
    (at cup1 cupboard)
    (at coffee-powder pantry)
    (empty cup1)
    (mission-running)

    ;; Initial numeric state.
    (= (elapsed-time) 0)
    (= (deadline) 18)
    (= (move-progress) 0)
    (= (current-move-duration) 0)
  )

  (:goal
    (and
      (served cup1)
      (not (deadline-missed))
    )
  )
)
