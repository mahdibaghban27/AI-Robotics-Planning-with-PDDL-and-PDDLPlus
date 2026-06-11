(define (problem d2v3-complex-layout)
  (:domain d2v3-domestic-mobile-manipulator)

  (:objects
    hallway cupboard sink pantry machine table - location
    cup1 - cup
    coffee-powder - ingredient
  )

  (:init
    ;; Spatially distributed kitchen layout.
    ;; The hallway is a hub, and one useful direct edge connects pantry and machine.
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

    ;; Functional locations.
    (water-source sink)
    (coffee-machine machine)
    (serving-place table)

    ;; Initial robot and object states.
    (robot-at hallway)
    (handempty)
    (at cup1 cupboard)
    (at coffee-powder pantry)
    (empty cup1)
  )

  (:goal
    (and
      (served cup1)
    )
  )
)
