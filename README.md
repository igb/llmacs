# llmacs

llmacs is an Elisp extension for the [Emacs](https://www.gnu.org/software/emacs/) text editor that enables a user to interact with [ChatGPT](https://chatgpt.com/) from insode an Emacs buffer.

## Installation Instructions

1. Download and save the file [llmacs.el](https://raw.githubusercontent.com/igb/llmacs/master/llmacs.el) to a local directory on the computer where you run Emacs.

2. Locate your *.emacs* file in your home directory and add the following line:
```Elisp
(load "/path/of/local/directory/where/file/was/saved/into/llmacs")
```
Note that you do not need the ".el" filename extension in the path, just the path of the local directory in which the downloaded file resides followed by the string "llmacs".

If you do not have a *.emacs* in your home directory go ahead and create an empty file and add the line described above.

```Shell
touch ~/.emacs; echo  '(load "/path/of/local/directory/where/file/was/saved/into/llmacs")' >> ~/.emacs
```

3. Configure ChatGPT credentials:

The llmacs extension is going to need your OpenAI API key in order to communicate with ChatGPT. To get these credentials visit the [Open AI platform site](https://platform.openai.com/docs/overview) and create an account and generate an API key.

On your local machine, create a *.llmacs* file in your home directory (*~/*) and add the API key in the following format/order:


```Text
API_KEY=sk-proj-vrGZ3026iVNIZKj5ip9onv7VvLVG6yC3zG3ErwFHYiCjqmVISq
```

Your key values will differ, obviously, but make sure the property name (API_KEY) is the same.

Ok, now you are good to go. Just launch or restart Emacs!

## How to use llmacs

**TL;DR:** *M-x llmacs*

### Details ###
1. In a new or existing buffer or file select the text you want to send as a prompt
3. *M-x llmacs* will send your selected text to ChatGPT as a chat prompt.
4. LLMs are relatively slow to respond, so be patient and keep an eye out on the Message minibuffer bar for updates.
5. Once a response has been recieved, llmacs will append the response to the current buffer, just below your selected text.
6. Subsequent invocations will preserve chat history (prompts and responses) to support multi-prompt, contextual discussions.
7. To start a new chat, clear chat history with the *M-x llmacs-new* command. 

## Questions? ##

You can always contact me with any questions at [@igb@mastodon.hccp.org](https://mastodon.hccp.org/igb).
