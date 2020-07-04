# a new hidden environment for the profile
.Rprofile <- new.env()


options(
  # set editor
  editor = "vim",

  # disable tcl/tk
  menu.graphics = FALSE,

  # no fancy quotes (edit: reduces reproducibility)
  # useFancyQuotes = FALSE,

  # warn on partial matches (edit: they're too noisy)
  # warnPartialMatchAttr = TRUE,
  # warnPartialMatchDollar = TRUE,
  # warnPartialMatchArgs = TRUE

  # <Enter> shouldn't repeats the previous command during debugging
  browserNLdisabled = TRUE
)


# more scrolling up in .Rhistory
Sys.setenv(R_HISTSIZE = "100000")


# don't blow up the R console
options(max.print = 200)


# install.packages() default package repo
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cloud.r-project.org/"
  options(repos = r)
})


# Warn about the packages only in an *interactive* session:
if (interactive()) {
  local({
    packages <- utils::read.csv(
      file.path(
        Sys.getenv("HOME"),
        "dotfiles/languages/R/packages.csv"
      )
    )
    installed_packages <- utils::installed.packages()
    not_installed <- !packages$package %in% installed_packages
    if (any(not_installed)) {
      not_installed_pkgs <- packages[not_installed,]
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
      cat(
        paste(
          " Note: Not all packages found in the system. Please run the\n",
          "script(s) below to install the recommended packages:\n\n",
          cran_msg,
          gh_msg
        ),
        "\n"
      )
    }
  })
}


options(
  # https://github.com/randy3k/radian/issues/135#issuecomment-574707750
  radian.complete_while_typing        = FALSE,
  radian.highlight_matching_bracket   = TRUE,
  radian.tab_size                     = 2,
  radian.insert_new_line              = FALSE,
  radian.history_search_no_duplicates = TRUE,
  # ignore case in history search
  radian.history_search_ignore_case   = TRUE
)


## special options when using R from terminal ----------------------

.Rprofile$vd <- function(x) {

  sym_calls <- list(
    list(
      name = "visidata",
      command = "vd",
      url = "https://www.visidata.org/"
    )
  )

  cmd_exists <- function(cmd_name) {
    cmd <- Sys.which(cmd_name)
    if (!nchar(cmd > 0L)) {
      url <- sym_calls[[
          which(
            sapply(sym_calls, `[[`, "command") %in% cmd_name
          )
          ]][["url"]]
      stop(
        sprintf(
          "%s cannot be found. See: %s\n",
          cmd_name,
          url
          ),
        call. = FALSE
      )
    }
  }

  call_system_external <- function(obj, cmd) {
    cmd_exists(cmd)
    tmp_name <- "r_view_"
    if (is.data.frame(obj)) {
      tmp_file <- tempfile(tmp_name, fileext = ".csv")
      write.csv(obj, tmp_file)
    } else if (is.list(obj) && !is.data.frame(obj)) {
      tmp_file <- tempfile(tmp_name, fileext = ".json")
      x_json <- jsonlite::toJSON(obj)
      write(x_json, tmp_file)
    } else {
      stop("?", call. = FALSE)
    }
    system2(cmd, tmp_file)
    on.exit(unlink(tmp_file), add = TRUE)
    invisible(NULL)
  }

  call_system_external(x, cmd = "vd")
}

#' Check if session is in an "interactive" terminal
#' @source
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

  # set prompt:
  options(prompt = "R>> ")
  options(continue = "... ")

  .vd <- .Rprofile$vd

}

# remove tmp environment
rm(.Rprofile)
