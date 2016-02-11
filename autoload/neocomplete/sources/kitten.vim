let s:Vital = vital#of('neocomplete_kitten')

let s:Process = s:Vital.import('Process')
let s:Json = s:Vital.import('Web.JSON')

let s:source = {
\   'name': 'kitten',
\   'kind': 'keyword',
\   'filetype': {
\       'swift': 1,
\   },
\   'mark': '[kitten]',
\   'min_pattern_length': 1,
\   'max_candidates': 10,
\ }

function! s:source.gather_candidates(context)
    let l:text = getline('.')
    let l:offset = col('.')

    let l:result = s:sourcekitten_complete(l:text, l:offset)

    let l:candidates = []

    for l:r in l:result
        let l:c = {
        \   'word': l:r.sourcetext,
        \}
        call add(candidates, l:c)
    endfor

    return l:candidates
endfunction

function! neocomplete#sources#kitten#define()
    return executable('sourcekitten') ? s:source : {}
endfunction

function! s:quote(string)
    return '"' . escape(a:string, '"') . '"'
endfunction

function! s:sourcekitten_complete(text, offset)
    let l:command = 'sourcekitten complete'

    let l:args = join(
    \   [
    \       '--text', s:quote(a:text),
    \       '--offset', a:offset,
    \   ],
    \)

    let l:result = s:Process.system(
    \   l:command . ' ' . l:args,
    \)

    return s:Json.decode(l:result)
endfunction
