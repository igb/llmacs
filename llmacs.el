
(defun llmacs()
  "Interact with ChatGPT"
 ;; write a haiku on tarriffs 
  (interactive)

  (if mark-active
      (let (
	    (selection (buffer-substring-no-properties (region-beginning) (region-end))))
	(if (= (length selection) 0)
	    (print "nothing selected")
	  (setq prompt (concat "{
                                \"model\": \"gpt-4o-mini\",
                                \"store\": true,
                                \"messages\": [
                                                 {\"role\": \"user\", \"content\": \""
	                                            selection
				                "\"}
                                               ]
                                  }"))
	  )
	


	))

  (get-response prompt)
  )

(defun get-response (prompt)
  "Connect to an LLM and get a response for the provided prompt."
  
  ; write a haiku about the music instrument cello
  
  (setq content-length (number-to-string(length prompt)))
  
  (setq headers (concat "Accept: */*\r\n"
			"Host: api.openai.com\r\n" 
			"Content-Type: application/json\r\n"
			"Content-Length: "
			content-length
			"\r\n"
			"Authorization: Bearer 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"))


  (setq conn (open-network-stream "llm" nil  "api.openai.com" 443  :type 'tls))
  (set-process-filter conn 'keep-llmacs-output)
  (setq body (concat "POST /v1/chat/completions HTTP/1.1\r\n" headers "\r\n\r\n" prompt))


  
  (process-send-string conn body)
  (print (process-buffer conn))

  )

				
(defun replace-with-prompt-and-response (message)
  (let (
	(selection (buffer-substring-no-properties (region-beginning) (region-end))))

    (kill-region (region-beginning) (region-end))
    (insert (concat selection "\n" message))
    )
  )


(defun keep-llmacs-output (process output)
  "Manage and process output anc check status of Toot action."
  (sleep-for 3) ;; async is hard 
  (setq lines (split-string output "\r\n" t))
  (if (string-prefix-p "HTTP/1.1 200 OK" (car lines))
      (replace-with-prompt-and-response "yo")
    (handle-error lines))
   
  (delete-process conn))


(defun handle-error (lines)
  "Handle error or non-200 condition!"
  (mapcar (lambda (x)
	    
	    (if (string-prefix-p "{\"errors\":" x)
		(message (concat "ERROR: " (car (cdr (reverse (split-string x  "[\"]"))))))
	      (print x)
	       )
	    )
	  lines)
   )
