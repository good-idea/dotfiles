## Sessions

:new<CR>  new session
s  list sessions
$  name session
g - prompts for session name and switches to it. Performs 'kind-of' name completion.
Faster than the built-in prefix + s prompt for long session lists.
C (shift + c) - prompt for creating a new session by name.
X (shift + x) - kill current session without detaching tmux.
S (shift + s) - switches to the last session.
The same as built-in prefix + L that everyone seems to override with some other binding.
@ - promote current pane into a new session.
Analogous to how prefix + ! breaks current pane to a new window.





## Windows (tabs)

c           new window
,           name window
w           list windows
f           find window
&           kill window
.           move window - prompted for a new number
:movew<CR>  move window to the next unused number

## Panes (splits)

%  horizontal split
"  vertical split

o  swap panes
q  show pane numbers
x  kill pane
⍽  space - toggle between layouts

## Window/pane surgery

:joinp -s :2<CR>  move window 2 into a new pane in the current window
:joinp -t :1<CR>  move the current pane into a new pane in window 1

* [Move window to pane](http://unix.stackexchange.com/questions/14300/tmux-move-window-to-pane)
* [How to reorder windows](http://superuser.com/questions/343572/tmux-how-do-i-reorder-my-windows)

