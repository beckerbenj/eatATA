

# minimal example item pool
####################################################################
items_mini <- data.frame(id = 1:30,
           format = c(rep("mc", 10), rep("open", 10), rep("order", 10)),
           mean_time = c(rnorm(10, mean = 25, sd = 5), rnorm(10, mean = 60, sd = 15), rnorm(10, mean = 40, sd = 15)),
           difficulty = rnorm(30, mean = 0, sd = 1),
           stringsAsFactors = FALSE)

usethis::use_data(items_mini, overwrite = TRUE)


# item pool van der Linden & Diao (2011)
####################################################################
nItems_c <- c(23, 26, 22, 29, 29, 36)
nItems <- sum(nItems_c)
set.seed(9286)
items_diao <- data.frame(Item = seq_len(nItems),
                   a = rnorm(nItems, .8, 0.2),
                   b = rnorm(nItems, -.15, 1),
                   c = rnorm(nItems, 0.2, .05),
                   Category = factor(sample(rep(1:6, nItems_c))))

usethis::use_data(items_diao, overwrite = TRUE)


# item pool example pilot study (SW)
####################################################################
nItems <- 100
set.seed(6402)

vec1 <- sample(c(rep(NA, 500), seq_len(nItems)), size = nItems)
vec2 <- sample(c(rep(NA, 500), seq_len(nItems)), size = nItems)
exclusions_ori <- apply(cbind(vec1, vec2), 1,
             function(x) paste(x[!is.na(x)], collapse = ", "))
exclusions <- ifelse(exclusions_ori == "", yes = NA, no = exclusions_ori)

items_pilot <- data.frame(Item = seq_len(nItems),
                        diff = sample(1:5, nItems, replace = TRUE),
                        format = factor(sample(c("mc", "cmc", "open"), nItems, replace = TRUE)),
                        domain = factor(sample(c("reading", "listening", "writing"), nItems, replace = TRUE)),
                        mean_time = rnorm(nItems, mean = 45, sd = 10),
                        exclusions = exclusions)

usethis::use_data(items_pilot, overwrite = TRUE)

# item pool example lsa (KS)
####################################################################
nItems <- 209
set.seed(5476)

formats <- c("multiple choice", "complex multiple choice","sentence completion", "open answer", "multiple matching", "true-false-not given")
testlet <- as.factor(c(rep(replicate(nItems%%4, paste0("TR", paste(sample(LETTERS, 1, replace=TRUE),collapse=""),paste(sample(0:9, 4, replace=TRUE),collapse=""))),each=nItems%%4+4),rep(replicate(nItems%/%4-1, paste0("TR", paste(sample(LETTERS, 1, replace=TRUE),collapse=""),paste(sample(0:9, 4, replace=TRUE),collapse=""))),each=4)))
testlet <- testlet[order(testlet)]
pool <- data.frame(testlet = testlet,
                   item = unlist(tapply(testlet,testlet,function(x) paste0(x,letters[seq(along=x)]))),
                   level=NA,
                   format = unlist(tapply(testlet, testlet, function(x) rep(sample(formats,2,replace=TRUE),each=sample(c(2,3),1))[seq(along=x)] )),
                   frequency = rbeta(nItems, 2, 2),
                   infit = rnorm(nItems, 1.05, .1),
                   time = round(rbeta(nItems, 2, 2)*100+30,0))
row.names(pool) <- seq_len(nItems)
a <- pool$frequency+ pool$frequency+rbeta(nItems,2,2)-1
pool$level <- ifelse(a < quantile(a)[2], "IV", ifelse(a < quantile(a)[3], "III", ifelse(a < quantile(a)[4], "II", "I")))
pool$anchor <- unlist(tapply(testlet, testlet, function(x) rep(sample(c(1,0), 1,prob=c(.2,.8)), length(x))))
pool[pool$anchor==1&pool$infit>1.3,"infit"] <- 1.115
items_lsa <- pool

usethis::use_data(items_lsa, overwrite = TRUE)


# based on real item pool (realistic data format)
####################################################################
## itempool as excel and rdata?
items_ori <- as.data.frame(readxl::read_excel(path = "T:/Pauline Kohrt/ATA in VERA3/V3_Pilot19_ZO_Blockbesetzungstabelle_190325.xlsm",
                                          skip = 13), stringsAsFactors = FALSE)


items2 <- tidyr::separate(items_ori, col = "Aufgabe", into = c("ID", "name"), sep = "_")

items2$ID <- gsub("MV190", "item_", items2$ID)
items2$Unverträglichkeiten <- gsub("MV190", "item_", items2$Unverträglichkeiten)

items3 <- items2[c("ID", "Unverträglichkeiten", "Zeit Aufg.", "Item-Anz.", "MC", "CMC (MC)", "KA2", "offen", 1:5)]
names(items3) <- c("Item_ID", "exclusions", "RT_in_min", "subitems", "MC", "CMC", "short_answer", "open", paste0("diff_", 1:5))

eatAnalysis::write_xlsx(items3, "inst/extdata/items.xlsx", row.names = FALSE)

items_vera <- items3
for(ty in c(paste0("diff_", 1:5), "MC", "CMC", "short_answer", "open")){
  items_vera[, ty] <- ifelse(is.na(items_vera[, ty]), yes = 0, no = 1)
}

usethis::use_data(items_vera, overwrite = TRUE)
