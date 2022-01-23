library(dplyr)
library(ggplot2)
library(ggpubr)
library(qualpalr)
require(cowplot)

# Load file.
dat <- as.data.frame(read.table(file = 'data/RBD_height.csv', sep = ',', header = FALSE))

# Order mutants according to amino acid numbering.
dat$V1 <- factor(dat$V1, levels = c("WT", "T128A", "V130I", "T135K", "A138S", "G186D", "G186V", "D190N", "F193S", "L194P", "S198P"))

# Plot RBD height for each mutant with +/- 1 standard deviation.
palette <- qualpal(n = 2, list(h = c(0, 360), s = c(0.4, 0.6), l = c(0.5, 0.85)))$hex
textsize <- 7
p_height <- ggplot(dat, aes(x = V1, y = V2)) +
  stat_summary(fun = "mean", geom = "point", color = palette[2], size = 0.3, alpha = 0.75) +
  stat_summary(fun.data = "mean_sdl", fun.args = list(mult=1), geom = "errorbar", color = palette[2], width = 0.3, size=0.3) +
  geom_dotplot(binwidth = 1/50, binaxis = "y", stackdir = "center", fill = "lightgray", dotsize = 2) + 
  theme_cowplot(12) +
  labs(x = "", y = "RBS height (Å)") +
  theme(axis.title = element_text(colour = "black", size = textsize, face = "plain"),
        axis.text.x = element_text(colour = "black", size = textsize, face = "plain", angle=90, hjust=1, vjust=0.5),
        axis.text.y = element_text(colour = "black", size = textsize, face = "plain"),
        legend.title = element_blank(),
        legend.key = element_blank(),
        legend.text = element_blank())

ggsave("graph/RBS_height.png", plot = p_height, width = 2.7, height = 1.3, units = "in", dpi = 600, bg='white')
