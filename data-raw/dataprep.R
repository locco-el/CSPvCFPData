# Code to clean raw data
library(data.table)
library(readxl)

# load raw data
rawdata_path <- system.file("extdata", "rawdata.csv", package = "CSPvCFPData")
rawdata <- fread(rawdata_path)

country_data_path <- system.file("extdata", "country_indices.xlsx",
  package = "CSPvCFPData"
)


exch_rates_path <- system.file("extdata", "exchange_rates.csv",
  package = "CSPvCFPData"
)

exch_rates_path
country_indices <- as.data.table(read_excel(country_data_path))

exchange_rates <- fread(exch_rates_path)
exchange_rates[, `:=`(V4 = NULL, V5 = NULL)]


setnames(country_indices, new = c("Country", "Year"), old = c("...1", "...2"))
# head(country_indices)

# categorize sectors
primary_goods <- c("Basic Materials", "Oil and Gas", "Utilities")
secondary_goods <- c("Consumer Goods", "Industrials")
tertiary_goods <- c(
  "Technology", "Healthcare", "Consumer Services",
  "Telecommunications"
)

rawdata[, Sector :=
  ifelse(sector %in% primary_goods, "Primary",
    ifelse(sector %in% secondary_goods, "Secondary",
      ifelse(sector %in% tertiary_goods, "Tertiary", NA)
    )
  )]

# rawdata[, table(Sector)]

# str(rawdata, list.len = 200)

# remove non-numeric characters from CFP variables and coerce them to numeric
rawdata[, `:=`(
  net_prof = CSPvCFPAfrica::coerce_num_cln(net_prof),
  tot_asst = CSPvCFPAfrica::coerce_num_cln(tot_asst),
  bk_eqt = CSPvCFPAfrica::coerce_num_cln(bk_eqt),
  market_value = CSPvCFPAfrica::coerce_num_cln(market_value)
)]

# View(rawdata[order(company, reporting_year), .(net_prof, company, reporting_year)])


# calc CFP variables (set infinite values to NA)
rawdata[, `:=`(
  `Return on Assets` = net_prof / tot_asst,
  `Return on Equity` = net_prof / bk_eqt
)][bk_eqt == 0, `Return on Equity` := NA][tot_asst == 0, `Return on Assets` := NA]


# drop outlier values of calculated CFP measures for later investigation
# -50 and 50 chosen as boundaries for outliers (subject matter decision
# re: discussion with APY)
rawdata[
  `Return on Equity` > 50 | `Return on Equity` < -50,
  `Return on Equity` := NA
][
  `Return on Assets` > 50 | `Return on Assets` < -50,
  `Return on Assets` := NA
]

# calc firm age vars
rawdata[, `:=`(
  Year = reporting_year,
  `Listing Age` = reporting_year - listing_year,
  `Incorp. Age` = reporting_year - incorporation_year
)]

setnames(rawdata, "company", "Company")

# ethics committee
rawdata[, `Social Comm.` := ifelse(social_committee == 0, "No", "yes")]

# character vars to factors
rawdata[, `:=`(
  Country = factor(listing_country),
  Multinational = factor(locality, labels = c("Yes", "No")),
  `Social Comm.` = factor(`Social Comm.`)
)]


# firm size
rawdata[, Company := toupper(Company)]
exchange_rates[, Company := toupper((Company))]
setkey(exchange_rates, "Company", "Year")
setkey(rawdata, "Company", "Year")

rawdata <- exchange_rates[rawdata]
rawdata[, `:=`(Size = tot_asst / ex_rate,
               `Net Profit` = net_prof / ex_rate)]
names(rawdata)

# View(rawdata[is.na(ex_rate), .(Company, Country, Year)])
# View(rawdata[is.na(Size), .(Company, Country, Year)])
# rawdata[order(Size, Company, Year), .(Company, Year, Size)]
#
# rawdata[Company %in% rawdata[Size < 10000, unique(Company)], .(Company, Year, Size)]
#
# tail(rawdata[order(Size), .(Company, Size)], 20)
#
# rawdata[Company == "HOSKEN CONSOLIDATED INVESTMENTS LTD", Size]

# create lagged CFP variables
# rawdata[order(Company, Year)]

rawdata[, `:=`(
  `Return on Assets (lagged)` =
    shift(`Return on Assets`, 1L, "lag"),
  `Return on Equity (lagged)` =
    shift(`Return on Equity`, 1L, "lag")
),
by = "Company"
]

# head(rawdata, 20)

# list CFP variables
CFP_vars <- c(
  "Company", "Year", "Country", "Multinational", "Sector",
  "Listing Age", "Incorp. Age", "Size",
  "Return on Assets (lagged)", "Return on Equity (lagged)",
  "Social Comm.", "Net Profit"
)


CFP_data <- rawdata[, CFP_vars, with = F]
str(CFP_data)
# head(CFP_data, n = 20)

# recode CSR variables from 0-5 to 0-2 (1:4 = 1, 5 = 2)
CSR_vars <- names(rawdata)[grepl(
  "com_|ene_|prod_|emi_|hr_|env_|oth_",
  names(rawdata)
)]

CSR_data <- rawdata[, lapply(
  .SD,
  function(x) {
    x <-
      ifelse(x %in% c(1:4), 1L,
        ifelse(x == 5, 2L, 0)
      )
  }
),
.SDcols = CSR_vars
]



# consolidate CSR variables by summing to create combined domains
com <- list(
  `Education CSR` = c("1", "2", "3", "9"),
  `Health CSR` = c("4", "5"),
  `Culture CSR` = c("6", "18"),
  `Economic CSR` = c("7", "8", "16"),
  `Agric. CSR` = c("11", "15", "17"),
  `Soc. Mobilization CSR` = c("12", "13", "14", "19", "20", "21", "22", "10")
)

hr <- list(
  `Emp. Safety CSR` = c("1", "2", "3", "4", "5"),
  `Emp. Diversity CSR` = c("7", "8", "30"),
  `Emp. Training CSR` = c("9", "10", "11"),
  `Emp. Benefits CSR` = c(
    "6", "12", "13", "21", "22", "23", "24",
    "26", "27", "28", "29"
  ),
  `Emp. Monitoring CSR` = c("14", "15", "18", "25"),
  `Emp. Satisfaction CSR` = c("16", "17", "19", "20")
)

prod <- list(
  `Prod. Info CSR` = c("1", "6"),
  `Prod. Quality CSR` = c("2", "3", "4", "5")
)

env <- list(
  `Pollution CSR` = c("1", "2", "3", "7", "12"),
  `Conservation CSR` = c("4", "5", "8", "15"),
  `Env. Policy CSR` = c("6", "9"),
  `Water Policy CSR` = c("10", "11", "13", "14")
)

ene <- list(
  `Energy Conserv. CSR` = c("1", "2", "3", "4"),
  `Energy Policy CSR` = c("5", "6", "7")
)

emi <- list(
  `Emissions Policy CSR` = c("1", "3", "4", "5", "6", "7"),
  `Emissions Mitigation CSR` = c("2", "8", "9", "10")
)

oth <- list(
  `Other CSR` = c(1:6)
)

csr_stems <- c("com", "hr", "prod", "ene", "emi", "env", "oth")

create_list_of_vars <- function(x, y) {
  paste0(x, "_", y)
}

csr_varlist <-
  unlist(lapply(
    csr_stems,
    function(x) {
      lapply(
        get(x),
        function(y) {
          create_list_of_vars(x, y)
        }
      )
    }
  ),
  recursive = F
  )

csr_varnames <- names(csr_varlist)

lapply(csr_varnames, function(x) {
  CSR_data[, x := rowSums(.SD), .SDcols = csr_varlist[[x]], with = F]
})


csr_domains <- names(CSR_data)[grepl("CSR$", names(CSR_data))]
# csr_domains

CSR_data <- (cbind(
  CFP_data[, .(Company, Year, Country, Sector)],
  CSR_data[, .SD, .SDcols = c(csr_domains)]
))

# head(CSR_data)
# str(CFP_data)

# deploy data to be
usethis::use_data(CSR_data, overwrite = TRUE)
usethis::use_data(CFP_data, overwrite = TRUE)
usethis::use_data(country_indices, overwrite = TRUE)
usethis::use_data(exchange_rates, overwrite = TRUE)
