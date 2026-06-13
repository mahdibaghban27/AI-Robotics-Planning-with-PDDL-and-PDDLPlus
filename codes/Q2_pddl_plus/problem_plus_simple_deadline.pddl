(define (problem d2v3-plus-simple-deadline)
  (:domain d2v3-domestic-mobile-manipulator-plus)

  (:objects
    counter sink machine table - location
    cup1 - cup
    coffee-powder - ingredient
  )

  (:init
    ;; Topology.
    (connected counter sink)
    (connected sink counter)
    (connected counter machine)
    (connected machine counter)
    (connected counter table)
    (connected table counter)

    ;; Movement durations in time units.
    (= (move-duration counter sink) 2)
    (= (move-duration sink counter) 2)
    (= (move-duration counter machine) 3)
    (= (move-duration machine counter) 3)
    (= (move-duration counter table) 1)
    (= (move-duration table counter) 1)

    ;; Functional locations.
    (water-source sink)
    (coffee-machine machine)
    (serving-place table)

    ;; Initial symbolic state.
    (robot-at counter)
    (handempty)
    (at cup1 counter)
    (at coffee-powder counter)
    (empty cup1)
    (mission-running)

    ;; Initial numeric state.
    (= (elapsed-time) 0)
    (= (deadline) 12)
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
