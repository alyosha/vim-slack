let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p:h')), ':h')

let s:cmd_forward_yanked = "FWD"
let s:cmd_send_user_input = "SEND"
let s:cmd_check_conversation = "CHECK"

com! -nargs=0 Fwd call s:GetConversations(s:cmd_forward_yanked)
com! -nargs=0 Send call s:GetConversations(s:cmd_send_user_input)
com! -nargs=0 Check call s:GetConversations(s:cmd_check_conversation)

fu! s:GetConversations(cmd_type)
  let l:cmd = s:plugin_root_dir . "/slack/get_user_conversations" . " " . a:cmd_type
  call job_start(l:cmd, {"out_cb": function("s:GetConversationsCallback")})
endfu

fu! s:GetConversationsCallback(channel, msg)
  if a:msg == ""
    return
  endif

  let l:output = split(a:msg, ':')
  let l:cmd_type = get(l:output, 0, "")
  let l:conversations = split(get(l:output, 1, []), ',')

  call s:PresentOptions(l:cmd_type, l:conversations)
endfu

fu! s:PresentOptions(cmd_type, options)
  vnew | exe 'vert resize '.(&columns/len(a:options))
  setl bh=wipe bt=nofile nobl noswf nowrap
  sil! 0put = a:options

  if a:cmd_type == s:cmd_forward_yanked
    nno <silent> <buffer> <nowait> <cr>  :<c-u>call<sid>ForwardYanked()<cr>
  elseif a:cmd_type == s:cmd_send_user_input
    nno <silent> <buffer> <nowait> <cr>  :<c-u>call<sid>SendUserInput()<cr>
  elseif a:cmd_type == s:cmd_check_conversation
    nno <silent> <buffer> <nowait> <cr>  :<c-u>call<sid>CheckConversation()<cr>:<c-u>close<cr>
  endif

  sil! $d_
  setl noma ro
  nno <silent> <buffer> <nowait> q :<c-u>close<cr>
endfu

fu! s:ForwardYanked()
  let l:selected_channel = expand("<cword>")
  let l:yanked_text = substitute(getreg('0'), '\\\@<!"', '\\"', 'g')

  if l:yanked_text == ""
    echom "Nothing yanked!"
    return
  endif

  let l:cmd = s:plugin_root_dir . "/slack/post_message" . " " . l:selected_channel . " \"" . l:yanked_text . "\"" . " block"
  call job_start(l:cmd)
endfu

fu! s:SendUserInput()
  let l:selected_channel = expand("<cword>")
  let l:msg = substitute(input('Input message and hit enter: '), '\\\@<!"', '\\"', 'g')
  let l:cmd = s:plugin_root_dir . "/slack/post_message" . " " . l:selected_channel . " \"" . l:msg . "\""
  call job_start(l:cmd)
endfu


fu! s:CheckConversation()
  let l:selected_channel = expand("<cword>")
  let l:cmd = s:plugin_root_dir . "/slack/get_conversation_history" . " " . l:selected_channel
  echom l:cmd
  call job_start(l:cmd, {"out_cb": function("s:CheckConversationCallback")})
endfu

fu! s:CheckConversationCallback(channel, msg)
  if a:msg == ""
    return
  endif
  call s:DisplayMessages(reverse(split(a:msg, "_MSG_START_")))
endfu

fu! s:DisplayMessages(options)
  vnew
  setl bh=wipe bt=nofile nobl noswf
  sil! 0put = a:options

  sil! $d_
  setl noma ro
  nno <silent> <buffer> <nowait> q :<c-u>close<cr>
endfu
