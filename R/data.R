#' Corporate social performance (CSP) data for selected African companies
#'
#' Dataset containing variables on 23 CSP domains, and 4 company characteristics
#' for 238 African companies spanning a period of 5 years (2014 to 2018)
#'
#' @format A data frame with 1195 rows, 27 variables:
#'
#' \describe{
#'   \item{Company}{Compnay name}
#'   \item{Year}{Reporting year}
#'   \item{Country}{Listing Country}
#'   \item{Sector}{Industrial Sector}
#'   \item{Education CSR}{Education interventions}
#'   \item{Health CSR}{Health  interventions}
#'   \item{Culture CSR}{Cultural activitess}
#'   \item{Economic CSR}{Economic activities}
#'   \item{Agric. CSR}{Agric support}
#'   \item{Soc. Mobilization CSR}{Social mobilization activities}
#'   \item{Emp. Safety CSR}{Improving worker safety}
#'   \item{Emp. Diversity CSR}{Workforce diversity}
#'   \item{Emp. Training CSR}{Workforce capacity building}
#'   \item{Emp. Benefits CSR}{Employee benefits}
#'   \item{Emp. Monitoring CSR}{Workplace statistics tracking}
#'   \item{Emp. Satisfaction CSR}{Worker satisfaction}
#'   \item{Prod. Info CSR}{Product information dissemination}
#'   \item{Prod. Quality CSR}{Product quality}
#'   \item{Energy Conserv. CSR}{Energy conservation activities}
#'   \item{Energy Policy CSR}{Energy policy}
#'   \item{Emissions Policy CSR}{Emissions policy}
#'   \item{Emissions Mitigation CSR}{Activities to mitigate emissions}
#'   \item{Pollution CSR}{Pollution reduction}
#'   \item{Conservation CSR}{Env. conservation activities}
#'   \item{Env. Policy CSR}{Env. policy}
#'   \item{Water Policy CSR}{Water conservation policy}
#'   \item{Other CSR}{Other CSR activities}
#' }
#'
#' @source Data gathered from published company annual reports
#'
"CSR_data"


#' Corporate financial performance (CFP) data for selected African companies
#'
#' A dataset containing variables on CFP and company characteristics
#' for 238 African companies spanning a period of 5 years (2014 to 2018)
#'
#' @format A data frame with 1195 rows, 12 variables:
#'
#' \describe{
#'   \item{Company}{Company name}
#'   \item{Country}{Country of origin}
#'   \item{Multinational}{Whether multinational}
#'   \item{Sector}{Economic sector }
#'   \item{Listing Age}{Years since listing}
#'   \item{Incorp. Age}{Years since incorporation}
#'   \item{Size}{Firm size in USD}
#'   \item{Return on Assets (lagged)}{Return on assest}
#'   \item{Return on Equity (lagged)}{Return on equity}
#'   \item{Social Comm.}{Existence of social and ethics commitee}
#'   \item{Year}{Reporting year}
#'   \item{Net Profit}{Reported annual net profit}
#' }
#'
#' @source Data gathered from published company annual reports
#'
"CFP_data"


#' Corporate social performance (CSP) scores
#'
#' A dataset containing CSP scores obtained from principal component analysis
#' of 23 CSP variables for 238 African companies spanning a period of 5 years
#' (2014 to 2018)
#'
#' @format A data frame with 1195 rows, 1 variable:
#'
#' @source Data gathered from published company annual reports
#'
"pca_ind_scores"


#' Country characteristics data
#'
#' A dataset containing selected socioeconomic and demographic
#' characteristics for 6 African countries for the
#' period 2014 to 2018)
#'
#' @format 30 rows, 7 variables
#'
#' \describe{
#'   \item{Country}{Country of origin}
#'   \item{Population}{Pop}
#'   \item{GDP $}{GDP in USD}
#'   \item{GPD/Capita}{Per capita GDP in USD}
#'   \item{Life expentancy}{Av. life expectancy at birth}
#'   \item{Corruption index}{Corruption Index}
#'   \item{Year}{Reporting year}
#' }
#'
#' @source Data gathered from World Bank
#'
"country_indices"


#' Exchange rate data characteristics data
#'
#' A dataset containing exchange rate data for 6 African currencies
#' from 2014 to 2018
#'
#' \describe{
#'   \item{Company}{Company name}
#'   \item{ex_rate}{Exchange rate rel to USD}
#'   \item{Year}{Reporting year}
#' }
#'
#' @source Data gathered from online
#'
"exchange_rates"
