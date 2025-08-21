TMUX CONFIG

#256 color
set -g default-terminal "tmux-256color"

set -g @catppuccin_window_text "#W"
set -g @catppuccin_window_current_text "#W"

set -g @catppuccin_flavor "latte"
set -g @catppuccin_window_status_style "rounded"

run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux

# Make the status line pretty and add some modules
set -g status-right-length 100
set -g status-left-length 100
set -g status-left ""
set -g status-right "#{E:@catppuccin_status_application}"
#set -agF status-right "#{E:@catppuccin_status_cpu}"
set -ag status-right "#{E:@catppuccin_status_session}"
set -ag status-right "#{E:@catppuccin_status_uptime}"
#set -agF status-right "#{E:@catppuccin_status_battery}"

#run ~/.config/tmux/plugins/tmux-plugins/tmux-cpu/cpu.tmux
#run ~/.config/tmux/plugins/tmux-plugins/tmux-battery/battery.tmux

# remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# More friendly split pane
bind-key h split-window -h
bind-key v split-window -v

# vi mode
set-window-option -g mode-keys vi


# default index 
set -sg escape-time 1
set -g base-index 1
setw -g pane-base-index 1

setw -g monitor-activity on
set -g visual-activity on
set -g history-limit 10000

# y and p as in vim
bind Escape copy-mode
unbind p
bind p paste-buffer
bind-key -T copy-mode-vi 'v' send -X begin-selection
bind-key -T copy-mode-vi 'y' send -X copy-selection
bind-key -T copy-mode-vi 'Space' send -X halfpage-down
bind-key -T copy-mode-vi 'Bspace' send -X halfpage-up

# bind h select-pane -L
# bind j select-pane -D
# bind k select-pane -U
# bind l select-pane -R

bind -r C-h select-window -t :-
bind -r C-l select-window -t :+

set -g status-position top
