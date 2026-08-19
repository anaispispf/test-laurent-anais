library(data.table)
library(ini)
library(ggplot2)
library(DBI)
library(scales)

fmt_fcfp <- label_number(big.mark=" ", decimal.mark=",", suffix=" F CFP", accuracy=1)
fmt_pct <- label_percent(decimal.mark=",", accuracy=0.1)
fmt_milliards <- label_number(scale=1e-9, suffix=" Md F CFP", big.mark=" ", decimal.mark=",", accuracy=0.1)

# Quantile pondéré
wquantile <- function(x, w, probs=seq(0,1,0.2)) {
  ok <- !is.na(x) & !is.na(w) & w > 0
  x <- x[ok]
  w <- w[ok]
  o <- order(x)
  x <- x[o]
  w <- w[o]
  cw <- cumsum(w)/sum(w)
  sapply(probs, function(p) x[which(cw >= p)[1]])
}