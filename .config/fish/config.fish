function is_mac
  return (test (uname) = Darwin)
end

function is_linux
  return (test (uname) = Linux)
end

function llvmenv
  if is_mac
    set -x LDFLAGS "-L/opt/homebrew/opt/llvm/lib/c++,/opt/homebrew/opt/llvm/lib -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"
    set -x CPPFLAGS "-I/opt/homebrew/opt/llvm/include"
    add_path "/opt/homebrew/opt/llvm/bin"
  else
    # linux: nothing to do
  end
end

function add_path
  if test (count $argv)
      fish_add_path $argv
  end
end

function vim
  if test -x (which nvim)
    nvim $argv
  else
    vim $argv
  end
end

set fish_greeting

# 放到最前面，后面有些命令会依赖
if is_mac
  eval (/opt/homebrew/bin/brew shellenv)
end

if type -q nvm
  nvm use &>/dev/null
end

# alias ls 'ls --color'
alias cls 'clear && echo -ne "\e[3J"'
alias jqless 'jq --color-output | less -r'
# alias less 'less --mouse --wheel-lines=3'
alias ffmpeg 'ffmpeg -hide_banner'
alias fd 'fd --no-ignore'

function less $argv
  env less $argv
end

set -gx EDITOR vim
set -gx ANDROID_SDK_ROOT (if is_mac; echo ~/Library/Android/sdk; else; echo /opt/android-sdk; end)
if type -q npm
  set -gx NODE_PATH (npm root -g)
end

for dir in ~/.local/opt/*/bin
  add_path $dir
end
add_path ~/.local/bin ~/scripts ~/script
add_path $ANDROID_SDK_ROOT/platform-tools
if is_mac
  add_path /Applications/Xcode.app/Contents/Developer/usr/bin
  add_path /opt/homebrew/opt/coreutils/libexec/gnubin
end

# pyenv
if type -q pyenv
  pyenv init - | source
end

# Wasmer
if test -d ~/.wasmer
  set -gx WASMER_DIR ~/.wasmer
  set -gx WASMER_CACHE_DIR "$WASMER_DIR/cache"
  add_path "$WASMER_DIR/bin" "$WASMER_DIR/globals/wapm_packages/.bin"
end

add_path ~/.cargo/bin/

set -gx RUSTUP_DIST_SERVER https://mirrors.tuna.tsinghua.edu.cn/rustup
