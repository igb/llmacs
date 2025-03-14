(defun llmacs()
  "Interact with ChattGPT"
  
  (interactive)


  (if mark-active
      (let (
	    (selection (buffer-substring-no-properties (region-beginning) (region-end))))
	(if (= (length selection) 0)
	    (print "nothing selected")
	  (print selection))



  )))
