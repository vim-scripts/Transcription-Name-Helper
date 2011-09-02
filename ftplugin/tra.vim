" Transcription Name Helper
" tra.vim v0.3
"
" A nice little script to write scripts (as in medical transcription, not vim
" scripts).
"
" This script allows the user to press <Tab> and in some modes ` to insert two newlines and the
" name of the next person to speak.
"
" NB, Personally, I put this in ~/.vim/ftplugin/ so that only *.tra files are
" affected.
"
" Changes in v0.3
" 	- New modes implemented
" 	- Emtpy line behaviour now changed
"
" Plans for the future include: 
" 	Perhaps a way to read from the *.tra file what to call everyone
"
" Created 2011-09-02 by nfarley88 
"
" Devnotes
" TODO fix the default mode to something. Bug test. Prepare for upload
" Optional: # could be a signal for tra.vim to read the tra file for the name " e.g.
" #transcriptionID1=PIDxxx
" or something like that. tra.vim would read that and make it happen!

" They are outside the function so that the user can define them with
" the :let command. Feel free to just change them here if you're going
" to be using them a lot.
let transcriptionID0 = "INTERVIEWER"
let transcriptionID1 = "INTERVIEWEE1"
let transcriptionID2 = "INTERVIEWEE2"
let transcriptionID3 = "INTERVIEWEE3"
let transcriptionID4 = "INTERVIEWEE4"

" It would make more sense to run ModeChooser here but I couldn't figure out
" how to do it so I just copied the code from tabspam mode.
inoremap <Tab> <Esc>:call TabspamTab()<CR>a

" This is literally what is typed to enter a name
" Before PrintMe() prints a name, it goes into normal mode and this is the key
" it presses to enter that mode. Sometimes, you'll want A, sometimes you'll
" want a, there's no way to tell really. I usually choose a as the cursor goes
" back a character when <Esc> is pressed.
let nameInsertMode = "a"

let tPTab = 1	
let tPFlick = 3
let maxPersons = 4

nnoremap <F6> :call ModeChooser()<CR>

" The point of the script!

" I made this function partially to save me typing this line again and again
" but mostly so the style of script can be easily controlled from one place
" This also replaces the EmtpyLineFunction before.
fun! PrintMe(transcriptionPerson)
	" This puts the paragraph break with the chosen insert mode
	execute "normal" . " " . g:nameInsertMode . "\r\r" 
	
	" Here, PrintMe checks if the previous line is 'empty'
	let deleteOrNot = getline(line("."))
	if match( getline(line(".")-2), ": $") !~ -1
		" and then deletes it if it is
		execute "normal kk2dd" 
		echo match( deleteOrNot, ": $")
	endif	

	" This inserts the name at the beggining of the line. 
	execute "normal gI" .  a:transcriptionPerson . ": "
endfun

" There is no AbsoluteTab because the function is so simple, it's denoted in
" ModeChooser()
"
" tab and conversation modes follow
fun! TabspamTab()
	" Set a dummy variable to use for choosing which name to place next
	let w = g:tPTab
	
	" Checking which name to output.
	if w =~ 1
		let transcriptionPerson = g:transcriptionID0
	elseif w =~ 2 
		let transcriptionPerson = g:transcriptionID1
	elseif w =~3 " this is ignored unless maxPersons > 2
		let transcriptionPerson = g:transcriptionID2
	elseif w =~4 " this is ignored unless maxPersons > 3
		let transcriptionPerson = g:transcriptionID3
	elseif w =~5 " this is ignored unless maxPersons > 4
		let transcriptionPerson = g:transcriptionID4
	endif
	" The bit that outputs your name.
	call PrintMe(transcriptionPerson)

	" Puts the counter on to the next person, ready for the next call.
	if g:tPTab < g:maxPersons
		let g:tPTab += 1
	else
		let g:tPTab = 1
	endif
endfun

fun! ConversationTab()
	if g:tPTab =~ 1
		let transcriptionPerson = g:transcriptionID0
		let g:tPTab = 2
	elseif g:tPTab =~ 2
               let transcriptionPerson = g:transcriptionID1
               let g:tPTab = 1
	endif

	" Print the person!
	call PrintMe(transcriptionPerson)

	" let ` give us the alternative person every time after a
	" <Tab> is pressed
	let g:tPFlick = 3
endfun

fun! ConversationFlick()
	if g:tPFlick =~ 3
		let transcriptionPerson = g:transcriptionID2
		let g:tPFlick = 2
	elseif g:tPFlick =~ 2
		let transcriptionPerson = g:transcriptionID1
		let g:tPFlick = 3
	endif

	" Print the person
	call PrintMe(transcriptionPerson)

	"let <Tab> give us the INTERVIEWER every time ` is used
	let g:tPTab = 1
endfun

" I should probably error check this. But I can't be bothered right now.
fun! ModeChooser()
	echo "You have accessed the ModeChooser function!"

	" Just unmap everything. Whatever happens next requires it so why
	" not?
	iunmap <Tab>
	iunmap `

	let g:transcriptionMode = input("Please type a mode (tabspam, conversation, absolute): ")

	if g:transcriptionMode =~ "tabspam"
		inoremap <Tab> <Esc>:call TabspamTab()<CR>a
	elseif g:transcriptionMode =~ "conversation"
		let g:tPTab = 1
		inoremap <Tab> <Esc>:call ConversationTab()<CR>a
		inoremap ` <Esc>:call ConversationFlick()<CR>a
	elseif g:transcriptionMode =~ "absolute"
		inoremap <Tab> <Esc>:call PrintMe(g:transcriptionID0)<CR>a
		inoremap <S-Tab> <Esc>:call PrintMe(g:transcriptionID1)<CR>a
		inoremap ` <Esc>:call PrintMe(g:transcriptionID2)<CR>a
		inoremap ¬ <Esc>:call PrintMe(g:transcriptionID3)<CR>a
	else
		echo "You have entered an invalid mode"
	endif
endfun
