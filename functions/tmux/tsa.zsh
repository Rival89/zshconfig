# Attach to exisiting tmux session
tsa(){
	tmux ls -F \#S > /dev/null 2>&1
	if [ $? -eq 0 ]
	then
		SESSION=$(tmux ls -F \#S | gum filter --placeholder "Attach to a TMUX session...")

		if [ ! -z "$SESSION" ]; then
			tmux attach -t "$SESSION"
		fi
	else
		echo "There is no existing TMUX session."
	fi
}
