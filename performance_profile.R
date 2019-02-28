setwd("~/Documents/r")
MODELS=c("model_A", "model_B", "model_KP")
COLUMNS = c("instance", "n_jobs", "n_occurrences", "model", "status", "obj", "time")
EPS = 0.00000000001

results = read.csv("./results.csv", sep=";", header=FALSE, col.names=COLUMNS)
# dp_results = read.csv("./results_dp.csv", sep=";", header=FALSE, col.names=COLUMNS)
#results = rbind(cplex_results, dp_results)

# compute min costs
min_costs = as.data.frame(aggregate(results$time~results$instance, FUN = min))
row.names(min_costs) = min_costs[,1]
colnames(min_costs) = c("instance", "min_cost")
for (model in MODELS) {
  model_results = results[results$model == model, c("instance", "time")]
  colnames(model_results) = c("instance", model)
  min_costs = merge(min_costs, model_results, by.x = "instance", by.y = "instance")
}
rownames(min_costs) = min_costs$instance
min_costs = min_costs[,-1]

r_sp = min_costs / (min_costs$min_cost + EPS)
r_sp = r_sp[,-1]

NB_INSTANCES = nrow(r_sp)
max_r_sp = max(r_sp);
min_r_sp = min(r_sp);

performance = function(s, t) {
  sum(r_sp[s] <= t) / NB_INSTANCES
}

dev.off()
par(mfcol=c(1, 1))
i = 1
color = c('red', 'blue', 'green', 'black')
for (model in MODELS) {
  x = seq(min_r_sp,max_r_sp,(max_r_sp - min_r_sp)/10000)
  y = sapply(x, FUN = function (t) performance(model, t))
  if (i == 1)  plot_function = plot
  else plot_function = lines
  
  plot_function(x, y, col = color[i], type = "l", ylim = c(.7, 1), xlim = c(0, 2e+10))
  i = i + 1;
}
legend(x = 1.5e+10, y= .8, legend = MODELS, col = color, lty = 1:2)

