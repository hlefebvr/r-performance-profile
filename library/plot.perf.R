default_colors = c('#e6194b', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#46f0f0', '#f032e6', '#bcf60c', '#fabebe', '#008080', '#e6beff', '#9a6324', '#fffac8', '#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075', '#808080', '#ffffff', '#000000')
default_colors = c("red", "green", "blue")

plot.perf = function(data, algorithm.col = "algorithm", instance.col = "instance",
                     acost.col = "cpu", eps = 1e-11, n = 1e4, col = default_colors) {
  relative_costs = rcost(data, algorithm.col, instance.col, acost.col, eps)
  print(head(relative_costs))
  
  n_color = length(col)
  n_instance = nrow(relative_costs)
  min_r = min(relative_costs)
  max_r = max(relative_costs)
  print(max_r)
  x = seq(min_r, max_r, (max_r - min_r) / n)
  
  algorithms = colnames(relative_costs)
  n_algorithm = length(algorithms)
  for (i in 1:n_algorithm) {
    algo = algorithms[i]
    plotter = ifelse(i == 1, plot, lines)
    y = sapply(x, FUN = function (t) sum(relative_costs[algo] <= t) / n_instance)
    
    plotter(x, y, type = "l", col = col[i], ylim = c(.7, 1), xlim = c(0, 2e+10))
  }
  legend(x = 1.5e+10, y= .8, legend = algorithms, col = col, lty = 1:2)
}

