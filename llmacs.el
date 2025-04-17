
(defun llmacs()
  "Interact with ChatGPT"

  (interactive)
  
  (read-llmacs-creds)

  (if mark-active
      (let (
	    (selection (buffer-substring-no-properties (region-beginning) (region-end))))
	(if (= (length selection) 0)
	    (print "nothing selected")
	  (setq prompt (concat "{
                                \"model\": \"gpt-4o-mini\",
                                \"store\": true,
                                \"messages\": [
                                                 {\"role\": \"user\", \"content\": "
	                                            (json-encode-string selection)
				                "}
                                               ]
                                  }"))
	  )
	


	))

  (get-response prompt)
  )

(defun get-response (prompt)
  "Connect to an LLM and get a response for the provided prompt."
  (setq content-length (number-to-string(length prompt)))
  
  (setq headers (concat "Accept: */*\r\n"
			"Host: api.openai.com\r\n" 
			"Content-Type: application/json\r\n"
			"Content-Length: "
			content-length
			"\r\n"
			"Authorization: Bearer "
			API_KEY))


  (setq conn (open-network-stream "llm" nil  "api.openai.com" 443  :type 'tls))
  (set-process-filter conn 'keep-llmacs-output)
  (setq body (concat "POST /v1/chat/completions HTTP/1.1\r\n" headers "\r\n\r\n" prompt))
  (message body)
  (message "talking to ChatGPT...")

  (setq kept nil)

  (process-send-string conn body)
  (sleep-for 3) ;; async is hard


  
  
  (if (null  (flatten-safe kept))
      (progn (message "waiting...")
	     (sleep-for 3)))

  
  (if (null  (flatten-safe kept))
      (progn (message "still waiting...")
	     (sleep-for 3)))

  (if (null  (flatten-safe kept))
      (progn (message "omg STILL waiting...")
	     (sleep-for 3)))

  (if (null  (flatten-safe kept))
      (progn (message "yep...still waiting...")
	     (sleep-for 3)))

    
  (if (null  (flatten-safe kept))
      (progn (message "JFC still waiting...")
	     (sleep-for 3)))

  (if (null  (flatten-safe kept))
      (progn (message "Ok, this has been a while...gonna wait like 5 more seconds.")
	     (sleep-for 5)))

  
  (if (null  (flatten-safe kept))
      (message "Took too long. I'm giving up.")
    (setq body-string (replace-regexp-in-string "\r+[0-9A-Fa-f[:space:]]+\r+" "" (format "%s" (flatten-safe kept))))
    
    (message body-string)
    (setq json-string (extract-json-from-string  body-string)) 
    (message json-string)
    (setq json-data (json-parse-string json-string))
    (replace-with-prompt-and-response
     (gethash "content"
	      (gethash "message"
		       (aref (gethash "choices" json-data) 0))))

    (message "done with prompt")
    )    
  
  (delete-process conn)
  )

 (defun replace-with-prompt-and-response (output)
   
   
   (let (
	 (selection (buffer-substring-no-properties (region-beginning) (region-end))))
     
     (kill-region (region-beginning) (region-end))
     (insert (concat selection "\n\n" output))
     )
   
   
   )
 

(defun keep-llmacs-output (process output)
  "Manage and process output anc check status of Toot action."
;;  (sleep-for 3) ;; async is hard
  (setq kept (cons kept output))
  )


(defun handle-error (lines conn)
  "Handle error or non-200 condition!"
  (mapcar (lambda (x)
	    
	    (if (string-prefix-p "{\"errors\":" x)
		(message (concat "ERROR: " (car (cdr (reverse (split-string x  "[\"]"))))))
	      (print x)
	       )
	    )
	  lines)

  
  (delete-process conn)
   )




(defun extract-json-from-string (input)
  "Extract the first valid JSON object or array from INPUT string."
  (let ((start (or (string-match "[{\[]" input) nil)))
    (when start
      (let ((depth 0)
            (in-str nil)
            (escaped nil)
            (i start)
            (len (length input)))
        (while (and (< i len)
                    (or (> depth 0) (= i start)))
          (let ((c (aref input i)))
            (cond
             ((and (not in-str) (member c '(?{ ?\[))) (setq depth (1+ depth)))
             ((and (not in-str) (member c '(?} ?\]))) (setq depth (1- depth)))
             ((and (not escaped) (eq c ?\")) (setq in-str (not in-str)))
             ((and in-str (eq c ?\\)) (setq escaped (not escaped)))
             (t (setq escaped nil))))
          (setq i (1+ i)))
        (substring input start i)))))



  (defun flatten-safe (x)
  "Flatten nested list X, handling dotted pairs correctly."
  (cond
   ((null x) nil)
   ((consp x)
    (append (flatten-safe (car x)) (flatten-safe (cdr x))))
   (t (list x))))



(defun read-llmacs-creds ()
  "Read auth tokens from local file"
  (if (file-exists-p "~/.llmacs")
      (read-creds-from-llmacs)
    (print "Could not find credentials at ~/.llmacs")
    )
  )



(defun read-creds-from-llmacs ()
  "Read auth tokens from ~/.llmacs"
  (with-temp-buffer
	(insert-file-contents "~/.llmacs")
	(setq raw-creds (split-string (buffer-string) "\n" t))
	(setq cred-nvps (mapcar (lambda (x) (split-string x "=")) raw-creds))
	(mapcar (lambda (x) (set (intern (car x)) (car (cdr x)))) cred-nvps)))


(defun create-message (role message)
  (concat  "{\"role\": \""
	   role
	   "\", \"content\": "
	   (json-encode-string selection)
	   "}"))
