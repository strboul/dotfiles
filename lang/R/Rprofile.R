# a tmp environment for the Rprofile
.Rprofile <- new.env()


# private Rprofile file (for private aliases & credentials etc.)
.Rprofile$rprofile_private <- path.expand("~/.Rprofile_private")
if (file.exists(.Rprofile$rprofile_private)) {
  source(.Rprofile$rprofile_private)
}


options(
  # set editor
  editor = "vim",

  # default browser
  browser = "chromium",

  # disable tcl/tk
  menu.graphics = FALSE,

  # no fancy quotes (edit: reduces reproducibility)
  # useFancyQuotes = FALSE,

  # warn on partial matches (edit: they're too noisy)
  # warnPartialMatchAttr = TRUE,
  # warnPartialMatchDollar = TRUE,
  # warnPartialMatchArgs = TRUE

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


# Warn about the packages only in an *interactive* session:
.Rprofile$warn_recommended_packages <- function() {
  if (interactive()) {
    packages <- utils::read.csv(file.path(
      Sys.getenv("HOME"),
      "dotfiles/lang/R/packages.csv"
    ))
    installed_packages <- utils::installed.packages()
    not_installed <- !packages$package %in% installed_packages
    if (any(not_installed)) {
      not_installed_pkgs <- packages[not_installed, ]
      generate_install_msg <- function(pkgs, call_name) {
        pkgs_len <- length(pkgs)
        if (!pkgs_len > 0L) return(NULL)
        pkgs_quoted <- paste("\"", pkgs, "\"", sep = "", collapse = ", ")
        if (pkgs_len > 1L) pkgs_quoted <- paste0("c(", pkgs_quoted, ")")
        sprintf("%s(%s)\n", call_name, pkgs_quoted)
      }
      cran_msg <- generate_install_msg(
        not_installed_pkgs[not_installed_pkgs$source == "CRAN", "package"],
        "install.packages"
      )
      gh_msg <- generate_install_msg(
        not_installed_pkgs[not_installed_pkgs$source == "GitHub", "link"],
        "remotes::install_github"
      )
      cat(paste(
        " Note: Not all the recommended packages found in the system. Please run\n",
        "the line(s) to install them:\n\n",
        cran_msg,
        gh_msg
      ), "\n")
    }
  }
  invisible()
}

.Rprofile$warn_recommended_packages()


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


## special calls when using R from the Terminal ----------------------

#' View a data frame in the browser with reactable
#' Note: Pagination is must for performance for the large tables.
#' @param x a.data.frame or a matrix.
#' @references
#' \url{https://glin.github.io/reactable/articles/examples.html}
.Rprofile$view_tbl <- function(x) {
  x <- mmy::std_rownames(x)
  x_len <- nrow(x)
  site_title <- deparse(match.call())
  call_reactable <- function() {
    reactable::reactable(
      x,
      searchable = TRUE,
      filterable = TRUE,
      showSortable = TRUE,
      bordered = TRUE,
      striped = TRUE,
      highlight = TRUE,
      compact = TRUE,
      height = 900,
      pagination = TRUE,
      showPageSizeOptions = TRUE,
      pageSizeOptions = c(10, if (x_len <= 100) x_len else c(100, x_len)),
      defaultPageSize = pmin(100, x_len)
    )
  }
  htmltools::browsable(
    htmltools::tagList(
      htmltools::tags$head(
        htmltools::tags$title(site_title)
      ),
      call_reactable()
    )
  )
}


#' Check if session is in an "interactive" terminal
#' @references
#' \url{https://github.com/r-lib/prettycode/blob/7275e2a9f972c8837e070cccaf5ef514643cf607/R/utils.R#L4#L11}
.Rprofile$is_terminal <- function() {
  interactive() &&
    isatty(stdin()) &&
    Sys.getenv("RSTUDIO") != 1 &&
    Sys.getenv("R_GUI_APP_VERSION") == "" &&
    .Platform$GUI != "Rgui" &&
    !identical(getOption("STERM"), "iESS") &&
    Sys.getenv("EMACS") != "t"
}


if (.Rprofile$is_terminal()) {

  options(prompt = "R>> ")
  options(continue = "... ")

  # utils::View is not great on terminal
  unlockBinding("View", getNamespace("utils"))
  assign("View", .Rprofile$view_tbl, getNamespace("utils"))
  lockBinding("View", getNamespace("utils"))

}

# remove tmp environment
rm(.Rprofile)
