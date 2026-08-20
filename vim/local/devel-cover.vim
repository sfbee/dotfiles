" ============================================================================
" ~/.vim/local/devel-cover.vim
"
" Local overrides for Devel::Cover::Report::Vim.  This file is found and
" sourced automatically by the generated cover_db/coverage.vim (it searches
" ~/.vim/** for a file named devel-cover.vim), so it must not be added to
" 'runtimepath' or sourced from .vimrc.
"
" Purpose: the generated script places signs whose 'linehl' points at the
" highlight groups "cov" and "err", which Devel::Cover leaves undefined -- so
" out of the box only the sign letter in the gutter is coloured.  Defining them
" here is what actually tints whole lines of Perl by coverage status.
"
"   green line  - criterion covered
"   red line    - criterion not covered (statement never run, branch/condition
"                 only ever taken one way, sub never called, POD missing)
"   dull red bg - the coverage data is older than the file on disk (stale)
"
" Gutter letters: P pod, S statement, R subroutine, B branch, C condition,
" T total.  The last criterion in that order wins, and any uncovered criterion
" beats a covered one.
" ============================================================================

let s:types = ["pod", "subroutine", "statement", "branch", "condition", "total"]

" The generated script only defines signs for pod/subroutine/statement/branch/
" condition.  'total' is reported by `cover` as well, so define it too rather
" than risk E155 on a file that has total data.
sign define total       linehl=cov texthl=cov_total       text=T
sign define total_error linehl=err texthl=cov_total_error text=T

" ---------- palette ----------
if &background ==# 'light'
  let s:fg_cover  = '#427b58'
  let s:fg_error  = '#9d0006'
  let s:bg_cover  = '#e4efd4'
  let s:bg_error  = '#f7dada'
  let s:bg_stale  = '#efe4c8'
  let s:ct_cover  = 22
  let s:ct_error  = 88
  let s:ctbg_cov  = 194
  let s:ctbg_err  = 224
  let s:ctbg_stal = 187
else
  let s:fg_cover  = '#8ec07c'
  let s:fg_error  = '#fb4934'
  let s:bg_cover  = '#1f2a1c'
  let s:bg_error  = '#3a1d1d'
  let s:bg_stale  = '#3a3320'
  let s:ct_cover  = 108
  let s:ct_error  = 203
  let s:ctbg_cov  = 22
  let s:ctbg_err  = 52
  let s:ctbg_stal = 58
endif

" ---------- gutter letters ----------
for s:type in s:types
  exe "highlight cov_" . s:type
        \ . " cterm=bold gui=bold ctermfg=" . s:ct_cover . " guifg=" . s:fg_cover
  exe "highlight cov_" . s:type . "_error"
        \ . " cterm=bold gui=bold ctermfg=" . s:ct_error . " guifg=" . s:fg_error
endfor

" ---------- whole-line highlighting ----------
" 'cov' tints covered lines, 'err' tints uncovered lines.  Only the background
" is set so syntax highlighting of the code underneath survives.
function! s:set_line_colours(bg_cover, ctbg_cover) abort
  exe "highlight cov ctermbg=" . a:ctbg_cover . " guibg=" . a:bg_cover
  exe "highlight err ctermbg=" . s:ctbg_err   . " guibg=" . s:bg_error
  exe "highlight SignColumn ctermbg=" . a:ctbg_cover . " guibg=" . a:bg_cover
endfunction

call s:set_line_colours(s:bg_cover, s:ctbg_cov)

" Called by coverage.vim: coverage data is current for this file.
function! CoverageValid(filename) abort
  call s:set_line_colours(s:bg_cover, s:ctbg_cov)
endfunction

" Called by coverage.vim: the file has been modified since the coverage run,
" so line numbers may have drifted.  Wash the covered lines amber as a warning.
function! CoverageOld(filename) abort
  call s:set_line_colours(s:bg_stale, s:ctbg_stal)
endfunction
