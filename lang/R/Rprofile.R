# a temp environment for the Rprofile
.Rprofile <- new.env()

# private Rprofile file (for private aliases & credentials etc.)
.Rprofile$rprofile_private <- file.path(Sys.getenv("HOME"), ".Rprofile_private")
if (file.exists(.Rprofile$rprofile_private)) {
  source(.Rprofile$rprofile_private)
}

options(
  # set editor
  editor = "vim",
  # default browser
  browser = "google-chrome-stable",
  # disable tcl/tk
  menu.graphics = FALSE,
  # <Enter> key shouldn't repeat the previous command at debugging
  browserNLdisabled = TRUE
)

# more scrolling up in .Rhistory
Sys.setenv(R_HISTSIZE = "100000")

# don't blow up the R console
options(max.print = 200)

# define default package repo for `install.packages`
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cloud.r-project.org/"
  options(repos = r)
})

# 'radian' options (https://github.com/randy3k/radian):
if (nchar(Sys.which("radian"))) {
  options(
    # disable complete_while_typing
    # https://github.com/randy3k/radian/issues/135#issuecomment-574707750
    radian.complete_while_typing        = FALSE,
    radian.highlight_matching_bracket   = TRUE,
    radian.tab_size                     = 2,
    # insert new line between prompts
    radian.insert_new_line              = TRUE,
    radian.history_search_no_duplicates = TRUE,
    # ignore case in history search
    radian.history_search_ignore_case   = TRUE,
    # don't auto match brackets and quotes
    radian.auto_match = FALSE
  )
}

# special calls when using R from the Terminal
if (interactive()) {
  options(prompt = "R>> ")
  options(continue = "... ")

  # some extra interactive checks in an interactive section
  if (!suppressWarnings(require("mmy", quietly = TRUE))) {
    # Warn about the packages only in an *interactive* session
    .Rprofile$packages <- utils::read.csv(file.path(
      Sys.getenv("HOME"),
      "dotfiles/lang/R/packages.csv"
    ))
    mmy::warn_recommended_packages(.Rprofile$packages)

    # if the interactive section is a terminal, i.e. not Rstudio console
    if (mmy::is_terminal()) {
      # `utils::View` is not great on terminal, replace with `mmy::view_tbl`
      unlockBinding("View", getNamespace("utils"))
      assign("View", mmy::view_tbl, getNamespace("utils"))
      lockBinding("View", getNamespace("utils"))
    }
    # unload mmy package
    detach("package:mmy", unload = TRUE)
  }
}

# remove tmp environment
rm(.Rprofile)
