# Notes-Vim  

## Example searches
```bash
/foo\(\(foo\)\@!\_.\)\{-}\d\{3}.\d\{3} ms\(\(foo\)\@!\_.\)\{-}foo
```
Search "xxx.xxx ms" between two "foo" (may be in diff lines) while other "foo" excluded  
* explain  
  `\@!` match zero width for preceding keyword  
  `\_.` any character including newline  
  `\{-}` match as few as possible  
  `\d` digit  
  `\{3}` repeat 3 times  
  `\(\(foo\)\@!\_.\)` any word excluding "foo"  
