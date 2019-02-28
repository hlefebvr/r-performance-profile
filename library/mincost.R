mincost = function(data, algorithm.col = "algorithm", instance.col = "instance", acost.col = "cpu", eps = 1e-12) {
  # compute minimal costs
  time_per_instance_formula = as.formula( paste("data$", acost.col, "~", "data$", instance.col, sep = "") )
  minimal_costs = as.data.frame(aggregate(time_per_instance_formula, FUN = min))
  
  # format output
  colnames(minimal_costs) = c(instance.col, "minimal_cost")
  
  minimal_costs
}
