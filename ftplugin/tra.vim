" Transcription Name Helper
" tra.vim v0.2
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
let tP2 = "INTERVIEWEE1"
let tP3 = "INTERVIEWEE2"
let tP4 = "INTERVIEWEE3"
let tP5 = "INTERVIEWEE4"
let tPCount = 1
let maxPersons = 2 

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
	elseif w =~4 " this is ignored unless maxPersons > 3
		let transcriptionPerson = a:tP4
	elseif w =~5 " this is ignored unless maxPersons > 4
		let transcriptionPerson = a:tP5
	endif

	" The bit that outputs your name.
	execute "normal" . " A\r\r" . transcriptionPerson . ": "
	
	" Puts the counter on to the next person, ready for the next call.
	if g:tPCount < a:maxPersons
		let g:tPCount += 1
	else
		let g:tPCount = 1
	endif
	call EmptyTranscriptLine()
endfunction

fun! EmptyTranscriptLine()
	" Check if the previous 'line' is 'empty'
	let deleteOrNot = getline(line("."))
	if match( getline(line(".")-2), ": $") !~ -1
		execute "normal kk2ddA"
		echo match( deleteOrNot, ": $")
	endif
endfun
