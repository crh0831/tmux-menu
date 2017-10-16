# tmux-menu.sh

A hack tmux menu script to manage multiple tmux sessions

---

After I discovered tmux I searched for a way to manage multiple groups of tmux sessions under one unified script.  

Not finding anything (or maybe just not looking well enough) I decided to write my own.

It ain't pretty, but I've been using for over a year now and it's become an integral part of my workflow.  Maybe
someone could benefit from it?  Or help me extend it?

My setup works this way:

Imagine you have multiple SSH connections

* web-dev
* web-prod
* database-dev
* database-prod

... and you want to group them together in similar groups.

With this script you can name collections of sessions and switch between them easily with just a few keystrokes.

Let's see an example using the above connections:

    case $session in
        web)
            if [[ $tcheck == 0 ]]; then
                tmux new-session -d -s web
                tmux rename-window 'local'
                tmux new-window -t 1 -n 'root@web-dev' 'exec ssh root@web-dev.example.org'
                tmux new-window -t:2 -n 'user@web-prod' 'exec ssh user@webprod.example.org'
            fi
        tmux attach-session -t web
    ;;

    case $session in
        database)
            if [[ $tcheck == 0 ]]; then
                tmux new-session -d -s database
                tmux rename-window 'local'
                tmux new-window -t 1 -n 'root@database-dev' 'exec ssh root@databasedev.example.org'
                tmux new-window -t:2 -n 'user@database-prod' 'exec ssh user@wdatabase.example.org'
            fi
        tmux attach-session -t database
    ;;


Calling the script with a pre-determined session name (ex: `./tmux-menu.sh web` or `tmux-menu.sh database`) first 
checks to see if there is already a session group with that name.  If not, it creates a new group with the 
commands you specify and names each connection in tmux.  

If the session group *does* already exist, it simply switches you to that group.

If you alias `tmux-menu.sh` to something shorter (like `tm`), switching between active sessions is as 
easy as `Ctrl-A + d` (to detach) and `tm web` (to attach or create the web group).

Killing session groups is as easy as `tmux-session kill -t web`.

