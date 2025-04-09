
(defun llmacs()
  "Interact with ChatGPT"
 ;; write a haiku on tarriffs 
  (interactive)

  (if mark-active
      (let (
	    (selection (buffer-substring-no-properties (region-beginning) (region-end))))
	(if (= (length selection) 0)
	    (print "nothing selected")
	  (print selection))



	))

  (setq prompt (concat "{
    \"model\": \"gpt-4o-mini\",
    \"store\": true,
    \"messages\": [
      {\"role\": \"user\", \"content\": \""
	"write a haiku on tarriffs"
	"\"}
    ]
  }"))


  
  (setq content-length (number-to-string(length prompt)))
  
  (setq headers (concat "Accept: */*\r\n"
			"Host: api.openai.com\r\n" 
			"Content-Type: application/json\r\n"
			"Content-Length: "
			content-length
			"\r\n"
			"Authorization: Bearer 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"))


  (setq conn (open-network-stream "llm" nil  "api.openai.com" 443  :type 'tls))
  (set-process-filter conn 'keep-output)
  (setq body (concat "POST /v1/chat/completions HTTP/1.1\r\n" headers "\r\n\r\n" prompt))


  
  (process-send-string conn body))

				
