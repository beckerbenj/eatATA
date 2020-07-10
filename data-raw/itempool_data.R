
## itempool as excel and rdata?
items_ori <- as.data.frame(readxl::read_excel(path = "T:/Pauline Kohrt/ATA in VERA3/V3_Pilot19_ZO_Blockbesetzungstabelle_190325.xlsm",
                                          skip = 13), stringsAsFactors = FALSE)


items2 <- tidyr::separate(items_ori, col = "Aufgabe", into = c("ID", "name"), sep = "_")

items2$ID <- gsub("MV190", "item_", items2$ID)
items2$Unverträglichkeiten <- gsub("MV190", "item_", items2$Unverträglichkeiten)

items3 <- items2[c("ID", "Unverträglichkeiten", "Zeit Aufg.", "Item-Anz.", "MC", "CMC (MC)", "KA2", "offen", 1:5)]
names(items3) <- c("Item_ID", "exclusions", "RT_in_min", "subitems", "MC", "CMC", "short_answer", "open", paste0("diff_", 1:5))

eatAnalysis::write_xlsx(items3, "inst/extdata/items.xlsx", row.names = FALSE)

items <- items3
for(ty in c(paste0("diff_", 1:5), "MC", "CMC", "short_answer", "open")){
  items[, ty] <- ifelse(is.na(items[, ty]), yes = 0, no = 1)
}

usethis::use_data(items, overwrite = TRUE)
