plot.perf = function(data, algorithm.col = "algorithm", instance.col = "instance",
                     acost.col = "cpu", eps = 1e-11, n = 1e4, col = NULL,
                     ylim = c(0,1), xlim = NULL, legend = NULL, main = NULL, xlab = NULL,
                     ylab = NULL, legendpos = NULL) {
  
  relative_costs = rcost(data, algorithm.col, instance.col, acost.col, eps)
  algorithms = colnames(relative_costs)
  n_algorithm = length(algorithms)
  n_color = length(col)
  n_instance = nrow(relative_costs)
  
  if (is.null(col)) col = c('#e6194b', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#46f0f0', '#f032e6', '#bcf60c', '#fabebe', '#008080', '#e6beff', '#9a6324', '#fffac8', '#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075', '#808080', '#ffffff', '#000000')
  if (is.null(legend)) legend = algorithms
  if (is.null(main)) main = "Performance Profile"
  if (is.null(xlab)) xlab = "Performance ratio"
  if (is.null(ylab)) ylab = "Instances solved"

  if (is.null(xlim)) {
    min_r = min(relative_costs)
    max_r = max(relative_costs)
  } else {
    min_r = xlim[1]
    max_r = xlim[2]
  }
  
  if (is.null(legendpos)) legendpos = c( max_r - (max_r - min_r) * .3, ylim[1] + (ylim[2]-ylim[1]) * .3)
  
  x = seq(min_r, max_r, (max_r - min_r) / n)
  
  for (i in 1:n_algorithm) {
    algo = algorithms[i]
    plotter = ifelse(i == 1, plot, lines)
    y = sapply(x, FUN = function (t) sum(relative_costs[algo] <= t) / n_instance)
    
    plotter(x, y, type = "l", col = col[i], ylim = ylim, xlim = xlim, main = main, xlab = xlab, ylab = ylab)
  }
  legend(x = legendpos[1], y= legendpos[2], legend = legend, col = col, lty = 1:2)
}
