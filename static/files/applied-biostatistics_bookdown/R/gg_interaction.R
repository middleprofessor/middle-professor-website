# interaction plot
# Jeffrey A Walker
# October 10, 2018

gg_interaction_plot <- function(x, y, data){
  # x is a vector of the column labels of categorical variables
  # y is the response
  dt <- data.table(data)
  dt[, ]
  dt_sum <- dt[, .(mean=mean(get(y), na.rm=TRUE),
                      sd=sd(get(y), na.rm=TRUE),
                      N=.N, # native but cannot account for missing?
                      N2=sum(!is.na(get(y))), # hard coded
                      se=sd(get(y)/sqrt(sum(!is.na(get(y)))), na.rm=TRUE)),
                  by=.(get(x[1]), get(x[2]))]
  setnames(dt_sum, old=c("get", "get.1"), new=(c("f1", "f2")))
  pd <- position_dodge(.5)
  gg <- ggplot(data=dt, aes(x=f1, y=mean, shape=f2,group=f2)) +
    #geom_jitter(position=pd, color='gray', size=2) +
    geom_point(data=dt_sum, aes(x=f1), color='black',
             size=4, position=pd) +
    geom_errorbar(data=dt_sum, aes(x=f1, ymin=(mean-se),
                    ymax=(mean+se)), color='black', width=.2,position=pd) +
    geom_line(data=dt_sum, position=pd) +
    xlab(x[1]) +
    ylab(y) +
    theme_bw() +
    guides(shape=guide_legend(title=x[2])) +
    theme(axis.title=element_text(size = rel(1.5)),
                     axis.text=element_text(size = rel(1.5)),
                     legend.title=element_text(size = rel(1.3)),
                     legend.text=element_text(size = rel(1.3))) +
    NULL
return(gg)
}
