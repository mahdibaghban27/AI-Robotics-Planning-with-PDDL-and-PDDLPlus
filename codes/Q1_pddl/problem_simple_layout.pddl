(define (problem d2v3-simple-layout)
  (:domain d2v3-domestic-mobile-manipulator)

  (:objects
    counter sink machine table - location
    cup1 - cup
    coffee-powder - ingredient
  )

  (:init
    ;; The kitchen topology is a small graph. Connections are explicit in both directions.
    (connected counter sink)
    (connected sink counter)
    (connected counter machine)
    (connected machine counter)
    (connected counter table)
    (connected table counter)

    ;; Functional locations.
    (water-source sink)
    (coffee-machine machine)
    (serving-place table)

    ;; Initial robot and object states.
    (robot-at counter)
    (handempty)
    (at cup1 counter)
    (at coffee-powder counter)
    (empty cup1)
  )

  (:goal
    (and
      (served cup1)
    )
  )
)
