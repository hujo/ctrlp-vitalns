## ctrlp-vitalns
Jump to the location of the function definition of vital.vim

### Requirement

- [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)
- [vital.vim](https://github.com/vim-jp/vital.vim)

### Usage

ctrlp-vitalns is getting a list of modules of vital.vim from helptag.  
Please create a helptag. See `:help helptag`  
If using the plugin manager, please refer to the there of help

```vim
" Example: Add 'vitalns' to g:ctrlp_extensions
let g:ctrlp_extensions = ['tag', 'buffertag', 'vitalns']

" Example: define a command
command! CtrlPVitalns call ctrlp#init(ctrlp#vitalns#id())
```
