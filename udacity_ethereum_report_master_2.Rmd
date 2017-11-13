---
output:
  md_document:
    variant: markdown_github
---
<U>Ether Historical Data by Richard James Lopez</U>
========================================================
## Project Details
This report details interesting explaratory data points for a Udacity Nanodegree
for Data Analysis project. This is a perfect opportunity to explore data
collected related to the cryptoassset Ether and it's blockchain of Ethereum. 

### R libraries used
```{r echo=TRUE, message=FALSE, warning=FALSE, packages}
# Useful libraries for project
library(gridExtra)
library(knitr)
library(ggplot2)
library(grid) 
library(tidyr)
library(dplyr)
library(xlsx)
library(GGally)
library(RColorBrewer)
library(anytime)
```

```{r echo=FALSE, message=FALSE, warning=FALSE, setup}

# setwd('/Users/RichardJamesLopez/Dropbox/udacity_ethereum_data-master')

```

### Files loaded
``` {r echo=TRUE, message=FALSE, warning=FALSE, setup2}
address <- read.csv("address_v2.csv",  header = TRUE)
all_data <- read.csv("all_data_v2.csv", header = TRUE)
Block_Size <- read.csv("block_size_v2.csv", header = TRUE)
block_difficulty <- read.csv("block_difficulty_v2.csv", header = TRUE)
etherprice <- read.csv('price_v2.csv', header = TRUE)
ethersupplygrowth <- read.csv('supply_v2.csv', header = TRUE)
hashrate <- read.csv('hashrate_v2.csv', header = TRUE)
marketcap <- read.csv('market_cap_v2.csv', header = TRUE)
tx <- read.csv('transactions_v2.csv', header = TRUE)
```

## <U>Data Overview </U>

The dataset was featured on Kaggle and utilizes an etherscan API. It features
a time series of data points for technological measurements like the average hashrate for a day as well as economic measures like total supply of Ether coin in circulation. I discovered the dataset here https://www.kaggle.com/kingburrito666/ethereum-historical-data and got the latest data from https://etherscan.io/charts.

### Content Overview 

The Ethereum blockchain gives a revolutionary way of decentralized applications and provides its own cryptocurrency. Ethereum is a decentralized platform that runs smart contracts: applications that run exactly as programmed without any possibility of downtime, censorship, fraud or third party interference. These apps run on a custom built blockchain, an enormously powerful shared global infrastructure that can move value around and represent the ownership of property. This enables developers to create markets, store registries of debts or promises, move funds in accordance with instructions given long in the past (like a will or a futures contract) and many other things that have not been invented yet, all without a middle man or counterparty risk.

## <U>Univariate Plots Section</U>
These charts and tables start to explore simple counts of the variables. There are also data summaries and definitions that help inform what the data set variables mean in real terms and in relation to each other.

### Basic Stats
To start, a count of the # of observations and variables for the complete  dataset. 

```{r echo=FALSE, message=FALSE, warning=FALSE, dimensions}
dim(all_data)
```

Also included is an overview of the variables. 

```{r echo=FALSE, message=FALSE, warning=FALSE, description_of_variables}
str(all_data)
```

For a less formal view of the variable, here are a set of definitions to describe the variables in laymen terms.

* <b>Date</b> - date for the corresponding row of data.

* <b>Day</b> - day of week that the date represents.

* <b>Unix_Time_Stamp</b> - the time stamp of each day. Taken at 12 AM (midnight) each day.

* <b>Transactions</b> - # of orders successfully recorded on the Ethereum blockchain. 

* <b>Address</b> - The number of public addresses key that are on the Ethereum blockchain. 

* <b>Price</b> - value of Ether to USD for the day at the Unix_Time_Stamp. 

* <b>Price_Change</b> - Simple change of price from previous day measured in % terms. <br/>

* <b>Supply</b> - amount of Ether coins in circulation.

* <b>Hashrate</b> - The number of hash calculations measured in GH/sec (for this dataset, the rate is a network hash rate for the whole ethereum blockchain in particular) - http://ethdocs.org/en/latest/glossary.html. It is representative of the combined power of the mining computers connected to the network. https://www.amazon.com/Cryptoassets-Innovative-Investors-Bitcoin-Beyond/dp/1260026671

* <b>Block_Difficulty</b> - In very general terms, the amount of effort required to mine a new block. Note that the difficulty algorithm is subject to change as what has happened with the launch  of Homestead on March 16, 2016. - http://ethdocs.org/en/latest/glossary.html 

* <b>Block_Size</b> - Ethereum’s block size is based on complexity of contracts being run – it’s known as a Gas limit per block, and the maximum can vary slightly from block to block. This data set of the average blocksize for the day.  https://bitsonblocks.net/2016/10/02/a-gentle-introduction-to-ethereum/ 

* <b>Market_Cap</b> - Value of ether multiplied by the supply of Ether coins at the time of the valualation (in USD). A rough proxy for how much value the total outstanding amount of Ether represents in global markets. Can be compared to the Market Cap of other cryptoassets. 


### Block Size Univariate Charts
As a starting point, the variable "Block_Size" is a good variable to examine. Of all the variables, there are the fewer preconveived notions about it given that is a fairly obscure measurement. 

```{r echo=FALSE, message=FALSE, warning=FALSE, summary_of_block_size}
summary(all_data$Block_Size)
```

### Block Size Histogram 
To start visualizing the data, a variable "Block_Size" is able to shine some light on how distributions may exist in the data. 

```{r echo=FALSE,message=FALSE, warning=FALSE,  univariate_plots_v1}
qplot(data = all_data, x = Block_Size, 
      binwidth = 500,
      color= I('pink'), 
      fill = I('#099DD9')) +
  scale_x_continuous(limits = c(min(all_data$Block_Size),
                                max(all_data$Block_Size))) +
  ggtitle('Block Size Histogram')
```

By halving the bidwidth to 250 there is a more nuanced view that decouples some of those lesser Block Size values. This is evident by the two horned values at the start of the chart to the left. 

```{r echo=FALSE, message=FALSE, warning=FALSE, univariate_plots_v2}
qplot(data = all_data, x = Block_Size, 
      binwidth = 250,
      color= I('pink'), 
      fill = I('#099DD9')) +
  scale_x_continuous(limits = c(min(all_data$Block_Size),
                                max(all_data$Block_Size))) +
  ggtitle('Block Size Histogram', 
          subtitle = "With 250 binwidth")
```

### Univariate_Plots_Transactions
To test the intuition behind these variables, a histogram with Transactions instead of Block Size should have similar dimensions . Logically, the amount of Transactions should help constitute how large the Block Size and we can test that logic here. Below are two histograms side by side with 100 bins. 

```{r echo=FALSE, message=FALSE, warning=FALSE, univariate_plots_v4}

q1 <- qplot(data = all_data, x = Block_Size, 
      bins = 200,
      color= I('red'), 
      fill = I('#4DBD33'))+
  scale_x_continuous(limits = c(min(all_data$Block_Size),
                                max(all_data$Block_Size))) +
  ggtitle('Block Size Histogram', subtitle = 'With 200 bins')

q2 <- qplot(data = all_data, x = Transactions, 
      bins = 200,
      color= I('green'), 
      fill = I('#4DBD33'))+
  scale_x_continuous(limits = c(min(all_data$Transactions),
                                max(all_data$Transactions))) +
  ggtitle('Transactions Histogram', subtitle = 'With 200 bins')

grid.arrange(q1, q2, ncol = 1)
```


The chart does appear to have a similar distribution, but it is hardly exact. This could be due to fewer but large transactions still being about to create a large Block. There will be more analysis with Block_Size and Transactions in more of the Bivariate and Multivariate charts too. 

### Univariate_Plots_Block_Size_90%Range
The Block_Size also seems to have a tail of large Block Size values with occurring less frequently. By cutting off 5% of each tail, a new picture could emerge. This trimming removed 84 of the rows containing the smallest and largest BlockSizes values.   

```{r echo=FALSE, message=FALSE, warning=FALSE, univariate_plots_v3}
qplot(data = all_data, x = Block_Size, 
      binwidth = 250,
      color= I('pink'), 
      fill = I('#099DD9')) +
  scale_x_continuous(limits = c(quantile(all_data$Block_Size,0.05),
                                quantile(all_data$Block_Size,0.95))) +
  ggtitle('Block Size Histogram', subtitle = 'Within 90% range')
```

This range of values, changes the distribution slightly (keeping binwidth of 250), and the left peak that existed earlier in chart Block_Size Histogram V2, but there is still the lingering values of big block sizes that exist on the right side of the chart. 

## <U>Univariate Analysis</U>
Below are a set of standard questions and answers for the univariate analysis.


<b>What is the structure of your dataset?</b>

> The structure of my data is a time series that tracks the features of the  cryptoasset Ether. 

<b>What is/are the main feature(s) of interest in your dataset?</b>

> The main features are possible relationships between variables of Ether. The price of Ether is relatively volatile compared to other assets and so I would like to explore relationships that may uncover behavior in Ether. The lesser known technical variables like "Block_Size", "Block_Difficulty", "Hashrate", and "Transactions" can inform an intuition on what relationships exist in Ethereum. 

<b>What other features in the dataset do you think will help support your \
investigation into your feature(s) of interest?</b>

> The more technical variables interest me but I will also more common place measurements like the "Day" of the week and "Price_Change". 


<b>Did you create any new variables from existing variables in the dataset?</b>

> Only the "Price_Change". This was possible because the Price values were collected at the same time of the every day. Caveat emptor because the price volatility throughout the day consequently changes the Price_Change measured. For this reason, I would take this Price_Change as an absolute metric because the change is relative to when a user might consider a good time to measure the price. That being said, since Ether trades 24/7, I don't think there is an absolute time to measure Price_change (unless you were measuring in real time as most websites do).

> Also, I technically I created the "Day"" variable although that was done with a simple excel formula. 


<b>Of the features you investigated, were there any unusual distributions? \
Did you perform any operations on the data to tidy, adjust, or change the form \
of the data? If so, why did you do this?</b>

> There was some unusual behavior in the 2 weeks of the Ethereum blockchain. For example, there are transactions on the first day with a zero price happening on the first day of trading. Also, once the price is a positive value, it goes back to 0 on the 12th day. This behavior required that I adjust my formula for Price_Change when compiling the data and creating this variable.  You can see in the row 12 of the data that there was a Price anomaly from the complete dataset. 


```{r echo=FALSE, message=FALSE, warning=FALSE, first_month}
head(all_data, 14)

```
## <U>Bivariate Plots Section</U>
These charts and tables dig further into the relationships between the variables. When particular variables are coupled together, it is apparent that subsetting as well as cutting off the tails for some distributions are worthwhile activities to understand the context of the data time series. 

### Basic Stats
To start out examing variables, a ggppairs chart may give some initial ideas for Bivariate plots to examine. 
```{r echo=FALSE, message=FALSE, warning=FALSE, bivariate_plots_summary}

all_data_subset = all_data[, c('Unix_Time_Stamp', 
                               'Transactions', 
                               'Block_Size', 
                               'Price_Change', 
                               'Supply', 
                               'Hashrate')]
names(all_data_subset)
ggpairs(all_data_subset) +
  ggtitle('', subtitle = '')
```

### Block Size <> Hashrate
Based on the Correlation charts above, there is a strong (0.964) correlation coefficient between the Block_Size and Hashrate. This makes sense technologically as more hashes would create a larger block. However, the technology for writing hashes has changed over the course of this time series. Visualizing the relastionship can show the story the correlation coefficient is telling. 


```{r echo=FALSE,message=FALSE, warning=FALSE, bivariate_plots_v2}
 s1 <- ggplot(data = all_data, aes(x = Hashrate, y = Block_Size)) +
  geom_jitter(color = I('#099DD9')) + 
  geom_smooth() +
  ggtitle('Hashrate <> Block Size Plot', subtitle = '')

all_data_block_size_small <- subset(all_data, Block_Size < 5000)

s2 <-ggplot(data = all_data_block_size_small, 
            aes(x = Hashrate, y = Block_Size)) +
  geom_jitter(color = I('#099DD9')) +
  ylim(0, max(all_data_block_size_small$Block_Size)) +
  xlim(0, max(all_data_block_size_small$Hashrate)) +
  geom_smooth() +
  ggtitle('Hashrate <> Block Size Plot', 
          subtitle = 'With all Block Size values under 5000 ')
  
grid.arrange(s1, s2, ncol=2)
```

The above chart to the left is interesting because there seems to be two data regimes. 

A block size of up until 5000 appears to have tight positive correlation to hashrate (relative
to blocks larger than 5000). Placing another scatter plot to the
right of it with the smaller subset of data will focus on the smaller block size. 

From this chart, maybe the Block_Size is not the main departure of behavior. Perhaps it has to do with blocks that have a hashrate of less than 10,000

```{r echo=FALSE,message=FALSE, warning=FALSE, bivariate_plots_hashrate}
all_data_hashrate_small <- subset(all_data, Hashrate < 10000)

ggplot(data = all_data_hashrate_small, 
       aes(x = Hashrate, y = Block_Size)) +
  geom_jitter(color = I('#099DD9')) +
  ylim(0, max(all_data_hashrate_small$Block_Size)) +
  xlim(0, max(all_data_hashrate_small$Hashrate)) +
  geom_smooth() +
  ggtitle('Hashrate <> Block Size Plot', 
          subtitle = 'With all Hashrate values less than 10,000')
```

This visualization shows that for small relative Block Sizes, hashrate is uncorrelated. There is a range of a hashrate of 0 to 10000. This may be due to upgraded technological protocol, the decreasing size of transaction value that may affect the hashrate, or just hard to scale block size as it get larger. This visualization begets new questions that weren't initially visible.  

### Market Cap <> Transactions
Another similar relationship is that for Market Cap and Transactions. It stands to reason that as the Market Cap increases, there will be more liquiditiy (Transactions per day as a proxy). 

```{r echo=FALSE, message=FALSE, warning=FALSE, bivariate_plots_v3}
ggplot(data = all_data, 
       aes(x = Market_Cap, y = Transactions, color= I('#099DD9'))) +
  geom_jitter() + 
  geom_smooth() +
  ggtitle('Market Cap <> Transactions Plot', subtitle = '')

```

Just as the Hashrates are increasing helping prove the Block_Size  robust, the Market Cap increases proves that Transactions will probably be more frequent. While not neceessarily true (you can have a large Market Cap with just a handful of Ether holders who do not making regular transactions), this chart appears to resemble that of the Block_Size <> Hashrate chart. 

### Price <> Time
One of the more vanilla relationships will be to examine Price behavior. 

```{r echo=FALSE,message=FALSE, warning=FALSE, bivariate_plots_v1}
ggplot(data = all_data, 
       aes(x = anytime(Unix_Time_Stamp), y = Price), 
       color= I('#099DD9')) +
  geom_line() +
  xlab('Date') +
  ggtitle('Date <> Price Chart', subtitle = '')

```

The price above shows the linear modeling of the Price which is generally not recommended for asset price. The plot below models regular behavior for asset prices by making sure to take the log10 value of the price (+1). 

```{r echo=FALSE, message=FALSE, warning=FALSE, bivariate_plots_price_updated}
ggplot(data = all_data, 
       aes(x = anytime(Unix_Time_Stamp), y = log10(Price + 1), 
           color= I('#099DD9'))) +
  geom_line() +
  xlab('Date') +
  ggtitle('Date <> Price Chart', subtitle = 'With log adjustments')

```

### Price Change <> Transactions
There also may be a relationship of # of transactions (perhaps as an undadjusted proxy for volume) to price change. To do this, one can subset the data so that it removed the beginning time period where there were price values of zero. 

Viewing the first rows of the data identifies when the Price have a continuous positive series. 8/11/15 is a proprer date to start. 


```{r echo=FALSE, message=FALSE, warning=FALSE, bivariate_plots_price_change_head}
head(all_data, 14)
```



```{r echo=TRUE, message=FALSE, warning=FALSE, bivariate_plots_price_change_subset}
all_data_post_zero <- subset(all_data, 
                             Unix_Time_Stamp >= 1439251200)
```


Now that the data is subset, below is the relationship between the Price Change (post-1st 2 weeks) and the # of Transactions.

```{r echo=FALSE, message=FALSE, warning=FALSE, bivariate_plots_v4}
ggplot(data = all_data_post_zero, 
       aes(x = Price_Change, y = Transactions), 
       color= I('#099DD9')) +
  geom_jitter(color= I('#099DD9')) + 
  geom_smooth() +
  xlab('Price Change in %') +
  ggtitle('Price Change <> Transactions Plot', 
          subtitle = '')

```

These charts seems to frame a cluster of data points between in single digits Price_Changes. This makes normal sense for normal asset price behavior. However, I don't want to use this somewhat aribitrary cutoff. Instead I will cut off the tails by 5% among the distribution.

```{r echo=FALSE, message=FALSE, warning=FALSE, bivariate_plots_v4_trimmed}
ggplot(data = all_data_post_zero, 
       aes(x = Price_Change, y = Transactions), 
       color= I('#099DD9')) +
  geom_jitter(color= I('#099DD9')) +
  xlim(quantile(all_data$Price_Change,0.05),
       quantile(all_data$Price_Change,0.95)) +
  geom_smooth() +
  xlab('Price Change in %') +
  ggtitle('Price Change <> Transactions Plot', subtitle = 'Within 90% range')

```

Within this range, I see that a majority of the data points less than +/- 10% (Note: 82 observations were removed from the dataset when the tails of the distribution were filtered out). The pattern that stands out though is how there a loose cluster of data points with high # of transactions that exists over a gap above a tighter cluster of low # of transactions. There could be several explanations for this. My intuition is that there is a significant uptick of transactions along our time series data. There is probably two difficult time periods to these data points. 

I can examine this future with a simple plot of the # of transactions over time. 

```{r echo=TRUE,message=FALSE, warning=FALSE, bivariate_plots_transaction_time_series}
ggplot(data = all_data, 
       aes(x = anytime(Unix_Time_Stamp), y = Transactions)) +
  geom_line(color = 'green') +
  xlab('Date') +
  ggtitle('Date <> Transactions Plot', 
          subtitle = '')
```

I contemplated cherrypicking what would be a good cutoff point. However for future rendering of this data, I simply decided to choose the middle point of the time series and approximately slice the data into two halves. 

With a summary, I can find the median point. 

```{r echo=FALSE, message=FALSE, warning=FALSE, bivariate_plots_price_change_summary}
summary(all_data$Unix_Time_)
```


```{r echo=TRUE, message=FALSE, warning=FALSE, bivariate_plots_price_change_subset_halves}
all_data_Transactions_1st <- subset(all_data_post_zero, 
                                    Unix_Time_Stamp <= 1.474e+09 )
all_data_Transactions_2nd <- subset(all_data_post_zero, 
                                    Unix_Time_Stamp > 1.474e+09 )
```

Now, let me create new charts with these two subsets. 

```{r echo=FALSE, message=FALSE, warning=FALSE, bivariate_plots_transaction_time_series_v2}
p3 <- ggplot(data = all_data_Transactions_1st, 
             aes(x = Price_Change, y = Transactions)) +
  geom_jitter(color= I('#099DD9')) + 
  geom_smooth() +
  xlab('Price Change in %') +
  ggtitle("1st Half of Time Series", 
          subtitle = "with Price_Change <> # of Transactions")

p4 <- ggplot(data = all_data_Transactions_2nd,
             aes(x = Price_Change, y = Transactions)) +
  geom_jitter(color= I('#9B30FF')) + 
  geom_smooth() +
  xlab('Price Change in %') +
  ggtitle("2nd Half of Time Series",
          subtitle = "with Price_Change <> # of Transactions")

grid.arrange(p3, p4, ncol=2)
```

Based on these charts above, one can observe that the scale of transaction numbers is bigger for the 2nd half of the history. However, there appears to be a similar pattern of transactions to price change. While it would be fruitful to examine the periods, no divergent patterns jump off the pageat first glance. 


## <U>Bivariate Analysis</U>
Below are a set of standard questions and answers for the bivariate analysis.

<b>Talk about some of the relationships you observed in this part of the \
investigation. How did the feature(s) of interest vary with other features in \
the dataset?</b>

> The parallel between Block Size <> Hashrate & Transactions <> Market Cap were something that I didn't originally suspect. The visualization helped play outsome logical relationships that I could posit, but coun't substantiate till I explored this data. 

<b>Did you observe any interesting relationships between the other features \
(not the main feature(s) of interest)?</b>

> I observed that there appears to be 2 different data clusters of Ether trading. Based on the chart titled "Price_Change <> Transactions". This may be due to a function of time or perhaps a technological protocol update. 


<b>What was the strongest relationship you found?</b>

> Unix_Time_Stamp and Supply. This makes sense as the supply of Ether coins was designed to be released on a publicized and regular schedule.

## <U>Multivariate Plots Section</U>

These charts are fewer but required considerable amount of time to decompose. The relationships are a little more nuanced and can hinge on a multiple logical insights. 

### Block_Size <> Day of the Week
The variable "Day" is unique to this dataset as most asset classes do not trade on the weekend. Ether does and so it is worth seeing how much it is traded on individual days.

```{r echo=FALSE, message=FALSE, warning=FALSE, bivariate_plots_v5}
ggplot(data = all_data, 
       aes(x = Block_Size, y = Transactions, color = I('#099DD9'))) +
  geom_jitter(alpha = 1/5) +
  facet_wrap(~ Day, ncol = 7) +
  scale_x_continuous(limits = c(0, max(all_data$Block_Size)), 
                     breaks = c(0,max(all_data$Block_Size),0)) +
  ggtitle('Block Size <> Transactions Plot', 
          subtitle = 'Grouped by Days of the Week')

```

The alpha parameter here is set to 1/5 meaning, there is a distinct blue dot when 5 observations overlap. This is meant to contrast how frequent there are low transactions days vs. high transactions days. However, there is not a compelling difference between the days of the weeks and so a box plot may illustrate differently. 


### Transactions <> Day of the Week
This chart simplifies the relationship by removing the Block Size variable and focusing on Transactions. 

```{r echo=FALSE, message=FALSE, warning=FALSE, transaction_daysofweek}
qplot(x= Day, y = Transactions, 
      data = all_data,
      geom = 'boxplot',
      color = I('#099DD9')) +
        coord_cartesian(ylim  = c(0, max(all_data$Transactions))) +
  xlab('Day of the Week') +
  ggtitle('Transactions <> Day of the Week Boxplot', subtitle = '')
```

This plot further corroborates 2 things
> 1) the 75th quantile is lowest for Saturday and Sunday, and 
> 2) the highest amount of transactions for both Saturday and Sunday are lower than the highest amount of transactions for all the other day of the weeks. 

We can make other observations about the busiest days being Thursday and Friday based on the 75th quantile points as well as the 2 datapoints with the most transactions also being on both of these days.


### Price Change <> Block Factors
Another factor that may affect volatility is the ability to fulfill a block. To test under what Block creation factors cause the greated rise and fall in price, one canadd a color scale to both the Block Size and Block Difficult variables,. One may seem visible differences a 3rd variable - Price Change in this case. Continuing the subset work done earlier, the first charts start off with the most recent time period (the second half of the non-zero Price time series) and made 2 charts. The one with the green highlights the conditions under which the biggest positive Price_Changes were. The one with red highlights the biggest negative Price_Changes. 


```{r echo=FALSE, message=FALSE, warning=FALSE, multivariate_plots_transcations_2nd}

p5 <- ggplot(all_data_Transactions_2nd, 
             aes(x = Block_Difficulty, y = Block_Size, 
                 colour = Price_Change)) +
  geom_point(alpha = 1) +
  scale_color_gradient(guide = "colourbar", 
                       low = "white", 
                       high = "#336600") +
  ggtitle('Block Difficulty <> Block Size', 
          subtitle = 'Grouped by price increase in green (2nd half of data)')

p6 <- ggplot(all_data_Transactions_2nd, 
             aes(x = Block_Difficulty, y = Block_Size, 
                 colour = Price_Change)) +
  geom_point(alpha = 1) +
  scale_color_gradient(guide = "colourbar", 
                       low = "#990033", 
                       high = "white") +
  ggtitle('Block Difficulty <> Block Size', 
          subtitle = 'Grouped by price decrease in red (2nd half of data)')

grid.arrange(p5, p6, ncol = 1)

```

The charts above do not appear to support the thesis that the Price Changes will be muted if there is more activity on the block chain. The darker red data points can be found along the spectrum. It is hard to discern a clear signal fromt his chart. 

Below is the same analysis with the original data set from the 1st half of transactions. 

```{r echo=FALSE, message=FALSE, warning=FALSE, multivariate_plots_transcations_1st}

p7 <- ggplot(all_data_Transactions_1st, 
             aes(x = Block_Difficulty, y = Block_Size, 
                 colour = Price_Change)) +
  geom_point(alpha = 1) +
  scale_color_gradient(guide = "colourbar", 
                       low = "white", 
                       high = "#336600") +
  ggtitle('Block Difficulty <> Block Size', 
          subtitle = 'Grouped by price increase in green (1st half of data)')


p8 <- ggplot(all_data_Transactions_1st, 
             aes(x = Block_Difficulty, y = Block_Size, 
                 colour = Price_Change)) +
  geom_point(alpha = 1) +
  scale_color_gradient(guide = "colourbar", 
                       low = "#990033", 
                       high = "white") +
  ggtitle('Block Difficulty <> Block Size', 
          subtitle = 'Grouped by price decrease in red (1st half of data)')

grid.arrange(p7, p8, ncol = 1)
```

This chart above gives the same mixed message about Price Changes based on anytime of Block chain dynamics. 


## <U>Multivariate Analysis</U>

<b>Talk about some of the relationships you observed in this part of the \
investigation. Were there features that strengthened each other in terms of \
looking at your feature(s) of interest?</b>

> Partially. There were some features that made perfect sense like # of Transactions to the Day of the week. However, when I considered the Block Size for Day of the week, there appeared to be noise and it didn't make sense in this rendering. By doing too much, it help me suss out what a clear relationship and remove what was unclear. 


<b>Were there any interesting or surprising interactions between features?</b>

> There were clusters of Block Difficulty and Block Size observations that coalesced around regular intervals of Block Difficulty for the 2nd subset of data (the more recent half of data). I couldn't see this in earlier scatter plots. However, once I created the same plot for the 1st half of data, the clusters at regular intervals dispersed. This leads me to the conclusion that the Block Difficulty is a more discrete function in the more recent period, perhaps due to technological protocol. For the 1st half of the data set, the Block Difficulty seemed to evolve in a such a way that there weren't large gaps in the data.

> Of note, this observation was a tangental insight from the main relationship I was trying to explore. The unintended discovery of it was one of the reasons why I left this chart as part of the analysis.


<b>OPTIONAL: Did you create any models with your dataset? Discuss the \
strengths and limitations of your model.</b>

> I tried to expand the model to incorporate the Price_Change variable. This proved to supply me with mixed visualizations that were hard to untangle. Especially when you plot Price Changes, adjusting the alpha parameters creates problems as one large Price Change can look a lot like many small Price Change as they equivicate to the same weight. I tried to create a couple of Multivariate plots with these parameters and ultimately had to pull them.

> Going forward, the Block Size and Block Difficulty probably won't be easy to model in terms of Price Change. However, other simple insights like trading on the weekend to look for larger Price Changes are valuable. 

> I also looked at the Hashrate logic for Block Size for future modeling. I observed that the lack ofcorrelation between Hashrate and Block Size as it applies to small block sizes. This is a sort of permissable dynamic for the infancy period of a Cryptoasset as developers work make a robust blockchain. As the Block Sizes increase, the hashrates adds more complexity and they work hand in hand towards sustaining a healthy, longlasting Cryptoasset. This contextualization of when a Cryptoasset is still in its infancy and when it is mature with a necessary amount of complexity is a key relationship I'd model in the future.

------

## <U>Final Plots and Summary</U>
The plots below are 3 of the most interesting as part of the anlaysis. In addition to the insights earlier described, I've included some commentary on the rationale of trying to create these plots. 

### Plot One - Price Change <> Transactions
```{r echo=FALSE, message=FALSE, warning=FALSE, bivariate_plots_v4_final}
all_data_post_zero <- subset(all_data, Unix_Time_Stamp >= 1439251200)

p1 <- ggplot(data = all_data_post_zero, 
             aes(x = Price_Change, y = Transactions), 
             color= I('#099DD9')) +
  geom_jitter(color= I('#099DD9')) + 
  geom_smooth() +
  xlab('Price Change in %') +
  ggtitle('Price Change <> Transactions Plot', 
          subtitle = '' )

p2 <- ggplot(data = all_data_post_zero, 
             aes(x = Price_Change, y = Transactions), 
             color= I('#099DD9')) +
  geom_jitter(color= I('#099DD9')) +
  xlim(quantile(all_data$Price_Change,0.05),
       quantile(all_data$Price_Change,0.95)) +
  geom_smooth() +
  xlab('Price Change in %') +
  ggtitle('Price Change <> Transactions Plot', 
          subtitle = 'Within 90% range')

grid.arrange(p1, p2, ncol=1)
```

### Description One
> This chart is unique because there appears to be a horizontal gap where the # of transactions seems to skip. I thought about this for a long time. Eventually, I posit that since there was such an abrupt rise of Transactions for Ether in early Summer of 2017, that there was a quick leap towards new levels of activity. This leap essentially leaves a gap in data because there is such a few amount of days that had Transaction count in this period.

> The chart below actually corroborates that when the Market Cap went from approximately 10,000 to 15,000, there were only a week or two of observations. It took time to arrive at this conclusion, but the visuzataions helped framed the thought process. 


```{r echo=FALSE, message=FALSE, warning=FALSE, bivariate_plots_v3_final}
ggplot(data = all_data, 
       aes(x = Market_Cap, y = Transactions, 
           color= I('#099DD9'))) +
  geom_jitter() + 
  geom_smooth() +
  ggtitle('', subtitle = '')

```




### Plot Two - Transactions <> Day of the Week
```{r echo=FALSE, message=FALSE, warning=FALSE, transaction_daysofweek_final}
qplot(x= Day, y = Transactions, 
      data = all_data,
      geom = 'boxplot',
      color = I('#099DD9')) +
        coord_cartesian(ylim  = c(0, max(all_data$Transactions))) +
  ggtitle('', subtitle = '')
```

### Description Two
> This chart was one of the simplest to make but it told an unequivocal message. I initially tried a more nuanced scatter plot, but no relationship was discernable. Once I put it into this quick plot, a relationship was easy to see with the box plots.  

### Plot Three - Price Change <> Block Factors
```{r echo=FALSE, message=FALSE, warning=FALSE, multivariate_plots_transcations_2nd_final}

p5 <- ggplot(all_data_Transactions_2nd, 
             aes(x = Block_Difficulty, y = Block_Size, 
                 colour = Price_Change)) +
  geom_point(alpha = 1) +
  scale_color_gradient(guide = "colourbar", 
                       low = "white", 
                       high = "#336600") +
  ggtitle('Block Difficulty <> Block Size', 
          subtitle = 'Grouped by price increase in green (2nd half of data)')

p6 <- ggplot(all_data_Transactions_2nd, 
             aes(x = Block_Difficulty, y = Block_Size, 
                 colour = Price_Change)) +
  geom_point(alpha = 1) +
  scale_color_gradient(guide = "colourbar", 
                       low = "#990033", 
                       high = "white") +
  ggtitle('Block Difficulty <> Block Size', 
          subtitle = 'Grouped by price decrease in red (2nd half of data)')

grid.arrange(p5, p6, ncol = 1)

```

### Description Three
> After adjusting the 3rd variable with many different Geom types (alpha parameters, point_size, continuous or discrete scale for color, etc), there was no clear signal that was definitive. I decided to keep this analysis in as a testament that you can't force a message if the data doesn't support it.  


### References
Original Dataset - https://www.kaggle.com/kingburrito666/ethereum-historical-data </br>
Current repository of dataset - https://etherscan.io/charts </br>
Necessary primer to understanding Cryptoassets - https://www.amazon.com/Cryptoassets-Innovative-Investors-Bitcoin-Beyond/dp/1260026671 </br>
Glossary - http://ethdocs.org/en/latest/glossary.html </br>
More Technical Glossary - https://bitsonblocks.net/2016/10/02/a-gentle-introduction-to-ethereum/</br>


## <U>Reflection</U>

This analysis is by no means exhaustive and quite the contrary. I enjoyed thinking about his data set and what questions I could answer with it. The exploratory data analysis tested my intuition as I thought I understood some of the more techical variables. While some of the relationships played out as expected, others played out for reasons I couldn't explain. This forced me to look at the technical documentation and blogs to get explanations for some of some of these variables. I also ended up with more questions than I originally had.

This exercise has started to make me think about the following in particular:

> * time series and whether subsetting it more would help going forward. 
> * the curious dynamics to the Block Size being added to the block chain. I thought there would be more variables that correlate to it, but the only variables with high correlation coefficients that I test were the Hashrate and Transactions. There has to be more to it as I hypothesized Block Size to be a sort of proxy for complexity or a possible disruptor. I found it be a bit more random than I suspected. 
> * no actionable variables appeared to be correlated to Price Change with this first exploration. This stands to reason because if there was an obvious relationship, participants would probably act on it and mute its effect by focusing on that relationship. The exploration still gave hints as to which directions may have more clues to a possible variable or relationship. 

I foresee updating this analysis every month or so. I am curious to see if these patterns, behavior and relationships hold over time as this data set continues on. Reach out to me at rjl2155(at)Columbia(dot)edu if you have any ideas on what I may be missing. 







```{r echo=FALSE, message=FALSE, warning=FALSE, univariate_plots_other_1}
# Other charts that I trashed. 

#ggplot(data = all_data, aes(x = Date, y = Transactions),
      #color= I('red'), 
      #fill = I('#4DBD33')) +
  #geom_bar(aes(x = Date, y = Transactions), color = 'red') +
  #geom_line(aes(x = Date, y = Block_Size), color = 'blue')
```


```{r echo=FALSE, message=FALSE, warning=FALSE, univariate_plots_other_2}
#qplot(data = all_data, x = Transactions, 
      #bins = 100,
      #color= I('red'), 
      #fill = I('#4DBD33')) +
  #scale_x_continuous(limits = c(quantile(all_data$Transactions,0.1),quantile(all_data$Transactions,0.90)))
```

```{r echo=FALSE, message=FALSE, warning=FALSE, sample_other_2}

```




