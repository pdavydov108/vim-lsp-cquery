let s:last_req_id = 0

function! s:request(method) abort
    let l:server_names = lsp#get_server_names()

    if len(l:server_names) == 0 || count(l:server_names, 'cquery') == 0
        echom 'Cquery language server not detected...'
        return
    endif

    call setqflist([])
    let s:last_req_id = s:last_req_id + 1

    let l:ctx = { 'counter': 1, 'list':[], 'last_req_id': s:last_req_id, 'jump_if_one': 0 }
    call lsp#send_request('cquery', {
        \ 'method': '$cquery/' . a:method,
        \ 'params': {
        \   'textDocument': lsp#get_text_document_identifier(),
        \   'position': lsp#get_position(),
        \ },
        \ 'on_notification': function('s:handle_location', [l:ctx, 'cquery', 'definition']),
        \ })

    echom 'Retrieving derived objects...'
endfunction

function! cquery#references#derived() abort
    call s:request('derived')
endfunction

function! cquery#references#base() abort
    call s:request('base')
endfunction

function! cquery#references#vars() abort
    call s:request('vars')
endfunction

function! cquery#references#callers() abort
    call s:request('callers')
endfunction

function! s:error_msg(msg) abort
    echohl ErrorMsg
    echom a:msg
    echohl NONE
endfunction

function! s:handle_location(ctx, server, type, data) abort "ctx = {counter, list, jump_if_one, last_req_id}
    if a:ctx['last_req_id'] != s:last_req_id
        return
    endif

    let a:ctx['counter'] = a:ctx['counter'] - 1

    if lsp#client#is_error(a:data['response'])
        call s:error_msg('Failed to retrieve '. a:type . ' for ' . a:server)
    else
        let a:ctx['list'] = a:ctx['list'] + lsp#ui#vim#utils#locations_to_loc_list(a:data)
    endif

    if a:ctx['counter'] == 0
        if empty(a:ctx['list'])
            call s:error_msg('No ' . a:type .' found')
        else
            if len(a:ctx['list']) == 1 && a:ctx['jump_if_one']
                normal! m'
                let l:loc = a:ctx['list'][0]
                let l:buffer = bufnr(l:loc['filename'])
                let l:cmd = l:buffer !=# -1 ? 'b ' . l:buffer : 'edit ' . l:loc['filename']
                execute l:cmd . ' | call cursor('.l:loc['lnum'].','.l:loc['col'].')'
                redraw
            else
                call setqflist(a:ctx['list'])
                echom 'Retrieved ' . a:type
                botright copen
            endif
        endif
    endif
endfunction

