
(define-rewriter (define-const form) 
  (cons 'define (cdr form)))

(define-rewriter (define-mask form)
  `(define-const ,(cadr form) ,(expt 2 (caddr form))))

#|
(define $event-codes 
  '#(#f #f KeyPress KeyRelease ButtonPress ButtonRelease MotionNotify EnterNotify LeaveNotify FocusIn FocusOut KeymapNotify Expose GraphicsExpose NoExpose VisibilityNotify CreateNotify DestroyNotify UnmapNotify MapNotify MapRequest ReparentNotify ConfigureNotify ConfigureRequest GravityNotify ResizeRequest CirculateNotify CirculateRequest PropertyNotify SelectionClear SelectionRequest SelectionNotify ColormapNotify ClientMessage MappingNotify #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f))

(define-const KeyPress			2)
(define-const KeyRelease		3)
(define-const ButtonPress		4)
(define-const ButtonRelease		5)
(define-const MotionNotify		6)
(define-const EnterNotify		7)
(define-const LeaveNotify		8)
(define-const FocusIn			9)
(define-const FocusOut			10)
(define-const KeymapNotify		11)
(define-const Expose			12)
(define-const GraphicsExpose		13)
(define-const NoExpose			14)
(define-const VisibilityNotify		15)
(define-const CreateNotify		16)
(define-const DestroyNotify		17)
(define-const UnmapNotify		18)
(define-const MapNotify		        19)
(define-const MapRequest		20)
(define-const ReparentNotify		21)
(define-const ConfigureNotify		22)
(define-const ConfigureRequest		23)
(define-const GravityNotify		24)
(define-const ResizeRequest		25)
(define-const CirculateNotify		26)
(define-const CirculateRequest		27)
(define-const PropertyNotify		28)
(define-const SelectionClear		29)
(define-const SelectionRequest		30)
(define-const SelectionNotify		31)
(define-const ColormapNotify		32)
(define-const ClientMessage		33)
(define-const MappingNotify		34)
|#

(define-mask $KeyPressMask			0)  
(define-mask $KeyReleaseMask			1)  
(define-mask $ButtonPressMask			2)  
(define-mask $ButtonReleaseMask			3)  
(define-mask $EnterWindowMask			4)  
(define-mask $LeaveWindowMask			5)  
(define-mask $PointerMotionMask			6)  
(define-mask $PointerMotionHintMask		7)  
(define-mask $Button1MotionMask			8)  
(define-mask $Button2MotionMask			9)  
(define-mask $Button3MotionMask			10) 
(define-mask $Button4MotionMask			11) 
(define-mask $Button5MotionMask			12) 
(define-mask $ButtonMotionMask			13) 
(define-mask $KeymapStateMask			14)
(define-mask $ExposureMask			15) 
(define-mask $VisibilityChangeMask		16) 
(define-mask $StructureNotifyMask		17) 
(define-mask $ResizeRedirectMask		18) 
(define-mask $SubstructureNotifyMask		19) 
(define-mask $SubstructureRedirectMask		20) 
(define-mask $FocusChangeMask			21) 
(define-mask $PropertyChangeMask		22) 
(define-mask $ColormapChangeMask		23) 
(define-mask $OwnerGrabButtonMask		24) 

(define-rewriter (X-event-mask form)
  (let ((accum 0))
    (for-each (lambda (f)
		(let ((b (assq f '((KeyPress . 1) 
				    (KeyRelease . 2)
				    (ButtonPress . 4)
				    (ButtonRelease . 8) 
				    (EnterWindow . 16)
				    (LeaveWindow . 32)
				    (PointerMotion . 64) 
				    (PointerMotionHint . 128) 
				    (Button1Motion . 256)
				    (Button2Motion . 512)
				    (Button3Motion . 1024)
				    (Button4Motion . 2048) 
				    (Button5Motion . 4096) 
				    (ButtonMotion . 8192) 
				    (KeymapState . 16384) 
				    (Exposure . 32768) 
				    (VisibilityChange . 65536)
				    (StructureNotify . 131072) 
				    (ResizeRedirect . 262144)
				    (SubstructureNotify . 524288)
				    (SubstructureRedirect . 1048576) 
				    (FocusChange . 2097152)
				    (PropertyChange . 4194304) 
				    (ColormapChange . 8388608)
				    (OwnerGrabButton . 16777216)))))
		  (if b
		      (set! accum (bitwise-or (cdr b) accum))
		      (error "(X-event-mask ~s): bad arg" f))))
	      (cdr form))
    accum))
#|
(define z '(
  (syntax-form ('KeyPress . more)
    (bitwise-or 1 (X-event-mask . more)))
  (syntax-form ('KeyRelease . more)
    (bitwise-or 2 (X-event-mask . more)))
  (syntax-form ('ButtonPress . more)
    (bitwise-or 4 (X-event-mask . more)))
  (syntax-form ('ButtonRelease . more)
    (bitwise-or 8 (X-event-mask . more)))
  (syntax-form ('EnterWindow . more)
    (bitwise-or 16 (X-event-mask . more)))
  (syntax-form ('LeaveWindow . more)
    (bitwise-or 32 (X-event-mask . more)))
  (syntax-form ('PointerMotion . more)
    (bitwise-or 64 (X-event-mask . more)))
  (syntax-form ('PointerMotionHint . more)
    (bitwise-or 128 (X-event-mask . more)))
  (syntax-form ('Button1Motion . more)
    (bitwise-or 256 (X-event-mask . more)))
  (syntax-form ('Button2Motion . more)
    (bitwise-or 512 (X-event-mask . more)))
  (syntax-form ('Button3Motion . more)
    (bitwise-or 1024 (X-event-mask . more)))
  (syntax-form ('Button4Motion . more)
    (bitwise-or 2048 (X-event-mask . more)))
  (syntax-form ('Button5Motion . more)
    (bitwise-or 4096 (X-event-mask . more)))
  (syntax-form ('ButtonMotion . more)
    (bitwise-or 8192 (X-event-mask . more)))
  (syntax-form ('KeymapState . more)
    (bitwise-or 16384 (X-event-mask . more)))
  (syntax-form ('Exposure . more)
    (bitwise-or 32768 (X-event-mask . more)))
  (syntax-form ('VisibilityChange . more)
    (bitwise-or 65536 (X-event-mask . more)))
  (syntax-form ('StructureNotify . more)
    (bitwise-or 131072 (X-event-mask . more)))
  (syntax-form ('ResizeRedirect . more)
    (bitwise-or 262144 (X-event-mask . more)))
  (syntax-form ('SubstructureNotify . more)
    (bitwise-or 524288 (X-event-mask . more)))
  (syntax-form ('SubstructureRedirect . more)
    (bitwise-or 1048576 (X-event-mask . more)))
  (syntax-form ('FocusChange . more)
    (bitwise-or 2097152 (X-event-mask . more)))
  (syntax-form ('PropertyChange . more)
    (bitwise-or 4194304 (X-event-mask . more)))
  (syntax-form ('ColormapChange . more)
    (bitwise-or 8388608 (X-event-mask . more)))
  (syntax-form ('OwnerGrabButton . more)
    (bitwise-or 16777216 (X-event-mask . more)))))
|#