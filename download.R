setwd("~/Documents/PCP/Code")

library(TCGAbiolinks)

projects = c(
  "TCGA-ACC",
  "TCGA-BLCA",
  "TCGA-BRCA",
  "TCGA-CESC",
  "TCGA-CHOL",
  "TCGA-COAD",
  "TCGA-DLBC",
  "TCGA-ESCA",
  "TCGA-GBM",
  "TCGA-HNSC",
  "TCGA-KICH",
  "TCGA-KIRC",
  "TCGA-KIRP",
  "TCGA-LAML",
  "TCGA-LGG",
  "TCGA-LIHC",
  "TCGA-LUAD",
  "TCGA-LUSC",
  "TCGA-MESO",
  "TCGA-OV",
  "TCGA-PAAD",
  "TCGA-PCPG",
  "TCGA-PRAD",
  "TCGA-READ",
  "TCGA-SARC",
  "TCGA-SKCM",
  "TCGA-STAD",
  "TCGA-TGCT",
  "TCGA-THCA",
  "TCGA-THYM",
  "TCGA-UCEC",
  "TCGA-UCS",
  "TCGA-UVM"
)
tcga.isoform <- NULL
for (project in projects) {
  print(paste("Loading project", project))
  filename <- paste0(project, "-isoform.rda")
  if (!file.exists(filename)) {
    print("  Downloading from GDC")
    query <- GDCquery(project = project,
                      experimental.strategy = "miRNA-Seq",
                      data.category = "Transcriptome Profiling",
                      data.type = "Isoform Expression Quantification")
    GDCdownload(query)
    isoform <- GDCprepare(query, save = TRUE, save.filename = filename)
  } else {
    print("  Loading from directory")
    load(filename)
    isoform <- data
  }
  print("  Complete. Appending")
  if (is.null(tcga.isoform)) {
    tcga.isoform <- isoform
  } else {
    tcga.isoform <- rbind(tcga.isoform, isoform)
  }
}

saveRDS(tcga.isoform, file = "TCGA-isoform.rds")
