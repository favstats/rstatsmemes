#' Display an R Meme at your convenience
#'
#' This function shows you an R Meme from the R Memes for Statistical Fiends Facebook page
#'
#' @param meme_index Index number of the meme that you want to be displayed. Defaults to \code{NULL}.
#' @param random_meme Show a random meme. Defaults to \code{TRUE}.
#' @param verbose Prints messages. Defaults to \code{TRUE}.
#' @examples
#'
#' ## show a random R meme
#' show_me_an_R_meme()
#'
#' ## show a specific R meme
#' show_me_an_R_meme(179)
#'
#' @export
show_me_an_R_meme <- function(meme_index = NULL, random_meme = T, verbose = T) {

  meme_posts <- meme_posts %>%
    dplyr::filter(!is.na(full_picture))

  if (!is.null(meme_index)){
    random_meme <- F
  }

  if (random_meme) {

    if (verbose) {
      message("\nChoosing a random meme...\n")
    }

    index <- sample(meme_posts$meme_number, size = 1)

  }

  if (!random_meme | !is.null(meme_index)) {

    if (is.null(meme_index)) {
      stop("You need to provide a meme_index")
    }

    index <- meme_index

  }


  meme <- meme_posts %>%
    dplyr::filter(meme_number == index)

  meme_path <- meme$full_picture
  meme_message <-  meme$message

  if (verbose) {

    message(paste0("\nDisplaying Meme #", index))

    message(stringr::str_glue("\n\nLikes: {meme$likes_count}\nComments: {meme$comments_count}\nShares: {meme$shares_count}\n\n"))

  }


  if (!is.na(meme$message) & verbose) {
    cat(meme_message)
  }

  img <- magick::image_read(meme_path)

  par(c(0, 0, 0, 0))
  plot(img)

}





# usethis::use_data(meme_posts)

# get_post_stats("227071407345158_2383340075051603", fb_oauth)


# get_post_stats("227071407345158_1497815846937368", fb_oauth)
