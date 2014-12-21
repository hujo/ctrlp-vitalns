## ctrlp-vitalns
Jump to the location of the function definition of vital.vim

## Requirement

[vital.vim](https://github.com/vim-jp/vital.vim)

### Usage

ctrlp-vitalns is getting a list of modules of vital.vim from helptag.  
Please create a helptag. see `:help helptag`

```vim
" Example: Add 'vitalns' to g:ctrlp_extensions
let g:ctrlp_extensions = ['tag', 'buffertag', 'vitalns']

" Example: define a command
command! CtrlPVitalns call ctrlp#init(ctrlp#vitalns#id())
```
