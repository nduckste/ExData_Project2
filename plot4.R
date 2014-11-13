a <- SCC[grep("coal",SCC$SCC.Level.Three),"SCC.Level.Three"]
a

names(SCC)
SCC[grep("Fuel Comb",SCC$EI.Sector) & grep("coal",SCC$SCC.Level.Three),c("EI.Sector","SCC.Level.Three")]

use %in% c("x","y") as SQL IN clause