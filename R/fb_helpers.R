get_content <- function(raw) {
  content <- xml2::read_html(raw) %>%
    rvest::html_node("body") %>%
    rvest::html_text() %>%
    jsonlite::fromJSON()

  return(content)
}


extract_posts <- function(tmp) {
  posts <- tmp %>%
    magrittr::extract2("data") %>%
    purrr::map(unlist) %>%
    # purrr::map(as.list) %>%
    # purrr::map(tibble::as_tibble) %>%
    dplyr::bind_rows()

  return(posts)
}



fb_authorization <- function() {
  FB_APP_ID <- Sys.getenv("FB_APP_ID")
  FB_APP_SECRET <- Sys.getenv("FB_APP_SECRET")

  ## Get token
  token <- Rfacebook::fbOAuth(FB_APP_ID,
                   FB_APP_SECRET,
                   scope = "manage_pages",
                   extended_permissions = FALSE,
                   legacy_permissions = FALSE)

  return(token)


}




get_fb_posts <- function(access_token) {

  url <- "https://graph.facebook.com/v3.3/Rmemes0/posts?access_token="

  call <- paste0(url, access_token)

  content <- get_content(call)

  return(content)

}

get_post_stats <- function(id, access_token) {
  url <- paste0("https://graph.facebook.com/v3.3/", id, "?fields=full_picture,shares,likes.summary(true).limit(0),comments.summary(true).limit(0)&access_token=")

  call <- paste0(url, access_token)

  # library(rvest)

  content <- get_content(call) %>%
    unlist() %>%
    as.list() %>%
    dplyr::bind_rows() %>%
    dplyr::select(-id)

  return(content)

}
