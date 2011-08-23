" Transcription Name Helper
" tra.vim v0.1
"
" A nice little script to write scripts (as in medical transcription, not vim
" scripts).
"
" This script allows the user to press <Tab> to insert two newlines and the
" name of the next person to speak.
"
" NB, Personally, I put this in ~/.vim/ftplugin/ so that only *.tra files are
" affected.
"
" Plans for the future include: 
" 	A way to specify which of multiple interviewees are to speak next
" 	Perhaps a way to read from the *.tra file what to call everyone
"
" Created 2011-08-23 by nfarley88 

" tP here stands for transcription person. Might make it longhand later, when
" I've finished the script. Also, they are outside the function so that the
" user can define them with the :let command. Feel free to just change them
" here if you're going to be using them a lot.
let tP1 = "INTERVIEWER"
let tP2 = "PID"
let tP3 = "[person 0]"
let tPCount = 1
let maxPersons = 2 " This is for future versions where one will be able to 
		   " choose how many interviewees to have. If you want it 
		   " badly now, you could make this 3 and delete the unused
		   " names somehow...

inoremap <Tab> <C-O>:call TP(tP1, tP2, tP3,tPCount ,maxPersons)<CR>

" The point of the script! TP stands for Transcription Person.
function! TP(tP1, tP2, tP3, tPCount, maxPersons)
	let w = a:tPCount
	
	" Checking which name to output.
	if w =~ 1
		let transcriptionPerson = a:tP1
	elseif w =~ 2 
		let transcriptionPerson = a:tP2
	elseif w =~3 " this is ignored unless maxPersons > 2
		let transcriptionPerson = a:tP3
	endif

	" The bit that outputs your name.
	execute "normal" . " A\r\r" . transcriptionPerson . ": "
	
	" Puts the counter on to the next person, ready for the next call.
	if g:tPCount < a:maxPersons
		let g:tPCount += 1
	else
		let g:tPCount = 1
	endif
endfunction
