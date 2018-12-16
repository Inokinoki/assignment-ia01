
; Node ((name . name) (type . type) (in-arc) (out-arc))
; Arc ((type . type) (from ...) (to ...))

;((name . Roxane) (type . individu) (in-arc) (out-arc))
;((name . Christien) (type . individu) (in-arc) (out-arc))

(setq nodes '())
(setq arcs '())

(defun defnode (name type)
	(let ((N (gentemp "N")))
		(set N (list (cons 'name name) (cons 'type type)))
		(push N nodes)
		N
	)
)

(defun defarc (type from to)
	(if (and (member from nodes) (member to nodes))
		 (let ((A (gentemp "A")))
		   	(set A (list (cons 'type type) (cons 'from from) (cons 'to to)))
		 	(push A arcs) 
			A
		 )
		 (error "No such element")
        )
)

(defun get_prop_val (id prop)
	(cdr (assoc prop (symbol-value id)))
)

(defun set_prop_val (id prop value)
	(setf (cdr (assoc prop (symbol-value id))) value)
)

; Need to be modified, add a value to a property
(defun add_prop_val (id prop val)
	(let ((pair (assoc prop (symbol-value id))))
		(if pair
			(set_prop_val id prop (cons val (cdr pair)))
			(push (cons prop val) (symbol-value id))
		)
		;(if pair
		;	(set_prop_val id prop val)
		;	(push (cons prop val) (symbol-value id))
		;)
	)
)

(defun mark_node (id mark)
	(add_prop_val id mark mark)
)

(defun get_marked_nodes (mark)
	(let ((marked_nodes NIL))
		(dolist (node nodes)
			(if (assoc mark (eval node))
				(push node marked_nodes)
			)
		)
		marked_nodes
	)
)

(defun wave (mark type-arc direction)
	(let ((new_marked_nodes NIL))
	(dolist (node (get_marked_nodes mark))
		(dolist (arc arcs)
			(if (equal type-arc (cdr (assoc 'type (eval arc))))
				(if (eq direction :inverse)
					(if (eq node (cdr (assoc 'from (eval arc))))
						(mark_node (cdr (assoc 'to (eval arc))) mark)
						(push (cdr (assoc 'to (eval arc))) new_marked_nodes)
					)
					(if (eq node (cdr (assoc 'to (eval arc))))
						(mark_node (cdr (assoc 'from (eval arc))) mark)
						(push (cdr (assoc 'to (eval arc))) new_marked_nodes)
					)
				)
			)
		)
	)
	new_marked_nodes	
	)
)

(defun get_results (mark node)
	(loop
		(let ((results (wave node 'is-a :inverse)))
            (print results)
			(if (assoc mark (eval node))
				(return T)
			)
			(if (= (list-length results) 0)
				(return NIL)	
			)
		)	
	)
)

(defnode 'DE-GUICHE 'individu)
(defnode 'CYRANO 'individu)
(defnode 'ROXANE 'individu)
(defnode 'CHRISTIAN 'individu)
(defnode 'ENORME 'individu)
(defnode 'NOBLE 'concept)
(defnode 'COMTE 'concept)
(defnode 'CADET-DE-GASCOGNE 'concept)
(defnode 'MONDAINE 'concept)
(defnode 'TAILLE 'concept)
(defnode 'NEZ 'concept)
(defnode 'REGIMENT 'concept)
(defnode 'SOLDAT 'concept)
(print (eval (defarc 'is-a 'N1 'N5)))
(print (eval (defarc 'is-a 'N4 'N5)))
(print (eval (defarc 'is-a 'N3 'N4)))
(print nodes)
(mark_node 'N4 'M2)
(mark_node 'N4 'M1)
(mark_node 'N2 'M1)
(mark_node 'N3 'M3)
(mark_node 'N4 'M4)
(mark_node 'N4 'M5)
(print (eval 'N4))
;(print (get_marked_nodes 'M1))
;(print (wave 'M2 'is-a :inverse))
(print (get_results 'M4 'N3))
(print (eval 'N3))
(print (eval 'N4))
