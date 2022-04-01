setwd("/data")
df <- read_dta("cash_flow_reg_data.dta")
dfcsmar <- read_dta("cash_flow_data.dta")
df <- dfcsmar[which(dfcsmar$stkcd %in% unique(df$stkcd)),]
df <- within(df, yearqtr <- paste(year,quarter,sep="_"))
stkcd <- fread("/idx/file.csv")
full_R2 <- data.frame()
df_list <- list()
    for(j in 1:dim(stkcd)[1]){
      df1 <- select(df[which(df$stkcd == stkcd[j,1]),],c("stkcd", "year", "quarter", "ocf_lag_mc"))
      df2 <- select(df[which(df$stkcd == stkcd[j,2]),],c("stkcd", "year", "quarter", "ocf_lag_mc"))
      dftemp <- merge(df1, df2, by = c("year","quarter"), all.x = T)
      dftemp <- dftemp[order(-dftemp$year,-dftemp$quarter),]
      dftemp <- dftemp[which(!is.na(dftemp$ocf_lag_mc.x) & !is.na(dftemp$ocf_lag_mc.y)),]
      stkcd_R2 <- as.data.frame(matrix(c(stkcd[j,1], stkcd[j,2],NA, NA,NA),nrow = 1))
      colnames(stkcd_R2) <- c("stkcd1","stkcd2","year","quarter","adj_R2")
      df_list[[j]] <- (dftemp)
      for(i in 1:(nrow(dftemp)-15)){
        t = nrow(dftemp)-i+1
        stkcd_R2[i,1] <- dftemp[t-15,"stkcd.x"]
        stkcd_R2[i,2] <- dftemp[t-15,"stkcd.y"]
        stkcd_R2[i,3] <- dftemp[t-15,"year"]
        stkcd_R2[i,4] <- dftemp[t-15,"quarter"]
        reg_df = dftemp[(t-15):t,]
        cash_flow_corr <- lm(ocf_lag_mc.x ~ ocf_lag_mc.y, data = reg_df)
        stkcd_R2[i,5] <- summary(cash_flow_corr)$adj.r.squared
      }
      full_R2 <- rbind(full_R22, stkcd_R2)
    }
setwd("/data")
fwrite(full_R2,"R2_cash_flow.csv",row.names = F)