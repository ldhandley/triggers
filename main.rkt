#lang at-exp codespells

(require triggers/mod-info)

(require-mod rocks)
(require-mod fire-particles)
(require-mod hierarchy)
(require-mod spawners)

(define (trigger-zone-rune-img)
  (overlay
   (above
    (beside (rotate -135 (arrow)) (padding 40))
    (padding 40))
   (circle 30 'solid 'cyan)))

(define-classic-rune (trigger exp)
  #:background "blue"
  #:foreground (trigger-zone-rune-img) 
 (thunk
  (unreal-js @~a{
 (function(){
  var actor = new StaticMeshActor(GWorld, {X:@(current-x), Y:@(current-z), Z:@(current-y)});
  var smc = actor.StaticMeshComponent;
  smc.SetMobile();
  smc.SetStaticMesh(StaticMesh.Load('/Engine/BasicShapes/Cube.Cube'));
  actor.StaticMeshComponent.SetVisibility(false);
  actor.StaticMeshComponent.SetCollisionProfileName("trigger");
  actor.StaticMeshComponent.bGenerateOverlapEvents = true;

  var overlaps_disabled = false;
 
  actor.OnActorBeginOverlap.Add((overlapped, other) => {
  
   if(overlaps_disabled){
    return;
   }
  
   overlaps_disabled = true;
    
   var spawned =
   @(at
     [
        @~a{actor.GetActorLocation().X} ;Ugh, using ~a is gross...
        @~a{actor.GetActorLocation().Z} ;Flipping Z and Y
        @~a{actor.GetActorLocation().Y}
     ]
     (unreal-js-fragment-content (if (procedure? exp)
                                     (exp)
                                     exp 
                                     )));
                        
   overlaps_disabled = false;
   })
    return actor;
  })()

 }))
  )

(define-classic-rune-lang my-mod-lang #:eval-from main.rkt
  (trigger))


(module+ main
  (codespells-workspace ;TODO: Change this to your local workspace if different
   (build-path (current-directory) ".." ".."))
  
  (once-upon-a-time
   #:world (arena-world)
   #:aether (demo-aether
             #:lang (append-rune-langs #:name main.rkt
                     (my-mod-lang #:with-paren-runes? #t)
                     (rocks:my-mod-lang)
                     (hierarchy:my-mod-lang)
                     (spawners:my-mod-lang)
                     (fire-particles:my-mod-lang)))))

