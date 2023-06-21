# Default Theme

if patched_font_in_use; then
  TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
  TMUX_POWERLINE_SEPARATOR_LEFT_THIN=""
  TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
  TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=""
else
  TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◀"
  TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
  TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="▶"
  TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
fi

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-'black'}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-'white'}

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}

# See man tmux.conf for additional formatting options for the status line.
# The `format regular` and `format inverse` functions are provided as conveinences

FG=$(__normalize_color "$TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR")
BG=$(__normalize_color "$TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR")

# color when prefix is held down
PREFIX_COLOR=color99
# this determines the separator background when the prefix key is held
CURRENT_STATUS="#{?client_prefix,#[bg=$PREFIX_COLOR],#[bg=$BG]}"

# this determines the separator color when the window index == 1
# if the active window is 1, then this should change color, otherwise it has fixed color
FIRST_BG="#{?#{e|==:#{active_window_index},1},#{?client_prefix,#[bg=$PREFIX_COLOR],#[bg=$BG]},#[bg=$FG]}"

# this determines the separator color when the window index == active + 1
# otherwise, no separator
NEXT_FG="#{?#{e|==:#{window_index},#{e|+:#{active_window_index},1}},#[fg=$BG],#[fg=$FG]}"
NEXT_BG="#{?#{e|==:#{window_index},#{e|+:#{active_window_index},1}},#[bg=$FG],#[bg=$FG]}"

# this determines the separator color when the window index == active, consulting prefix status
# otherwise, try NEXT
ACTIVE_FG="#{?#{e|==:#{window_index},#{active_window_index}},#[fg=$FG],$NEXT_FG}"
ACTIVE_BG="#{?#{e|==:#{window_index},#{active_window_index}},$CURRENT_STATUS,$NEXT_BG}"

# all cases of standard separators
# 2. active -> inactive
# 3. inactive -> inactive
STANDARD_FG="$ACTIVE_FG"
STANDARD_BG="$ACTIVE_BG"

SEPARATOR_START=(
  "#[$(format normal)]" \
    # set the foreground of the first window-status to the correct color
  "#{?#{e|==:#{window_index},1},#[fg=color148],$STANDARD_FG}" \
    # set the background of the first window-status to the correct color
  "#{?#{e|==:#{window_index},1},$FIRST_BG,$STANDARD_BG}" \
  "$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
)
SEPARATOR_START=$(printf '%s' "${SEPARATOR_START[@]}")

# this is either a correctly colored LEFTSIDE_SEPARATOR if active == final otherwise empty
ACTIVE_FINAL="#{?#{e|==:#{last_window_index},#{active_window_index}},#[fg=$BG#,bg=$FG]$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR,}"
SEPARATOR_FINAL="#{?#{e|==:#{last_window_index},#{window_index}},$ACTIVE_FINAL,}"

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_CURRENT ]; then
  TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
    "$SEPARATOR_START" \
    "#[$(format inverse)]" \
    "#{?client_prefix,#[bg=$PREFIX_COLOR],}" \
    " #I#F" \
    "#[$(format inverse)]" \
    "#{?client_prefix,#[fg=$PREFIX_COLOR],}" \
    "#{?client_prefix,$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR,$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}" \
    "#[$(format inverse)]" \
    " #W " \
    "$SEPARATOR_FINAL"
  )
fi

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_STYLE ]; then
  TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
    "$(format regular)"
  )
fi

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_FORMAT ]; then
  TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
    "$SEPARATOR_START" \
    "#[$(format regular)]" \
    " #I#{?window_flags,#F, }" \
    "$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN" \
    " #W " \
    "$SEPARATOR_FINAL"
  )
fi

# Format: segment_name background_color foreground_color [non_default_separator] [separator_background_color] [separator_foreground_color] [spacing_disable] [separator_disable]
#
# * background_color and foreground_color. Formats:
#   * Named colors (chech man page of tmux for complete list) e.g. black, red, green, yellow, blue, magenta, cyan, white
#   * a hexadecimal RGB string e.g. #ffffff
#   * 'default' for the defalt tmux color.
# * non_default_separator - specify an alternative character for this segment's separator
# * separator_background_color - specify a unique background color for the separator
# * separator_foreground_color - specify a unique foreground color for the separator
# * spacing_disable - remove space on left, right or both sides of the segment:
#   * "left_disable" - disable space on the left
#   * "right_disable" - disable space on the right
#   * "both_disable" - disable spaces on both sides
#   * - any other character/string produces no change to default behavior (eg "none", "X", etc.)
#
# * separator_disable - disables drawing a separator on this segment, very useful for segments
#   with dynamic background colours (eg tmux_mem_cpu_load):
#   * "separator_disable" - disables the separator
#   * - any other character/string produces no change to default behavior
#
# Example segment with separator disabled and right space character disabled:
# "hostname 33 0 {TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD} 33 0 right_disable separator_disable"
#
# Note that although redundant the non_default_separator, separator_background_color and
# separator_foreground_color options must still be specified so that appropriate index
# of options to support the spacing_disable and separator_disable features can be used

if [ -z $TMUX_POWERLINE_LEFT_STATUS_SEGMENTS ]; then
  TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
    "tmux_session_info 148 234 x 0 0 none separator_disable " \
    #"ifstat 30 255" \
    #"ifstat_sys 30 255" \
    #"lan_ip 24 255 ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}" \
    #"wan_ip 24 255" \
    #"vcs_branch 29 88" \
    #"vcs_compare 60 255" \
    #"vcs_staged 64 255" \
    #"vcs_modified 9 255" \
    #"vcs_others 245 0" \
  )
fi

if [ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]; then
  TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
    "hostname 33 0" \
    #"earthquake 3 0" \
    #"pwd 89 211" \
    #"macos_notification_count 29 255" \
    #"mailcount 9 255" \
    #"now_playing 234 37" \
    #"cpu 240 136" \
    #"load 237 167" \
    #"tmux_mem_cpu_load 234 136" \
    #"battery 137 127" \
    #"weather 37 255" \
    #"rainbarf 0 ${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR}" \
    #"xkb_layout 125 117" \
    #"date_day 235 136" \
    "date 235 136" \
    #"time 235 136" \
    #"utc_time 235 136 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
  )
fi
