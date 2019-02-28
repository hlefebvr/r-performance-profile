rcost = function(data, algorithm.col = "algorithm", instance.col = "instance", acost.col = "cpu", eps = 1e-12) {
  minimal_costs = mincost(data, algorithm.col, instance.col, acost.col, eps)
  
  absolute_costs = reshape( data[, c(instance.col, algorithm.col, acost.col)], idvar = instance.col, timevar = algorithm.col, direction = "wide"  )
  
  rownames(absolute_costs) = absolute_costs[,1]
  
  absolute_costs[,-1] / (minimal_costs$minimal_cost + eps)
}
