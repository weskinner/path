# path package

shortcuts for working with path strings.

###Features
- **Insert Relative to Me**: inserts the path of a project file you select
using the fuzzy finder relative to the current file. `alt-cmd-r`
- **Insert Relative to ...**: inserts the path of a project file you select
 relative another file or directory you select.  For example, if you select
 `/site/www/js/api/lib/beanCounter.js` and then `www/js`, the path `js/api/lib/beanCounter`
 will be inserted. Useful for js and css includes in web apps. `alt-cmd-t`
- **Insert Full Path**: inserts the full path of a file you select. `alt-cmd-i`
- **Pull Path Up**: pulls the current selection up a directory. `/path/to/file.txt`
becomes `/path/file.txt`. `alt-cmd-u`
