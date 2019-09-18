plug_file='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
curl -fLo ~/.vim/autoload/plug.vim --create-dirs "${plug_file}"

echo "you need to open vim and run PlugInstall to finish the setup procedure"
echo -e "you should also create symbolic links for:\n~/.vimrc -> ~/_vimrc\n~/.vim -> ~/_vim"
