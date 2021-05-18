# ii-utils.el

A set of helper functions for our team.

## Adding to your doom config
in `packages.el`

``` emacs-lisp
(package! ii-utils :recipe
  (:host github
   :repo "ii/ii-utils"))
```

Then in your `config.org`

```
#+BEGIN_SRC
(use-package! ii-utils)
#+END_SRC
```
