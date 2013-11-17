# Working with Tables

R has great built-in support for working with data in tabular format.  Tables in R are called "data frames."  By convention, response and annotation variables are arranged across the columns and observations down the rows.  Columns, and optionally rows, can also be given unique names.


### A note about table structure for Excel users

Before we dive into loading and working with tabular data in R, it's worth taking a moment to consider a key difference between data formatting expectations in advanced statistical software packages like R and the bad habits most folks develop after years of working in Excel.  If you're used to working in other stats packages like SAS, SPSS or Minitab, you can skip this section.

Let's consider a simple example experimental design:  a response variable measured in two different treatment groups (A, B) over a 4 day period.  Excel has probably trained you to format the data something like this:

  Day | Group A | Group B
  --- | ------- | -------
  1   | 5       | 5
  2   | 6       | 7
  3   | 7       | 9
  4   | 8       | 11


The reason we have all learned to format the data this way in Excel is that it makes it easy to produce plots -- if we select these cells and click the scatter plot wizard, we'll get the desired plot with Day on the X-axis and two sets of points, one for Group A and the other Group B.

Statisticians, and by proxy statistical software packages, object to this formatting for an important reason.  The problem is that we've mixed our concerns in designing the structure of these columns:  (1) *two* different columns contain values for the *same* response being measured; (2) a second variable in this design (treatment) has to be inferred from the column headings.  

The correct design would be a three column table, where each column describes *one and only one* variable in the experiment:
  
  Day | Group   | Response
  --- | ------- | -------
  1   | A       | 5
  1   | B       | 5
  2   | A       | 6
  2   | B       | 7
  3   | A       | 7
  3   | B       | 9
  4   | A       | 8
  4   | B       | 11


If you have a lot of data formatted in the first of these two formats, don't worry.  Restructuring your tables is easy to do in R, as is generating any new categorical label columns you might need.  We can explore this topic in more detail if there's interest, but as a preview the tools you'll probably need are the `c(..., recursive = TRUE)` and `rep()` functions.


### Loading tabular data

R can import tabular data from a wide variety of source file formats.  Base R has excellent support for loading data using the `read.table` family of functions.  There are also a wide array of R packages that support loading data from databases and other binary file formats.  If you just need to move data from an Excel worksheet into R, the easiest path is to save it as a text file (tab-delimited or csv) and load it into R using `read.table`. 

If you're working in [RStudio](http://www.rstudio.com/), you can use the "Import Dataset" button on the Workspace tab to load data from a local file or over the web.  Under-the-hood RStudio is just calling `read.table` for you, which we'll explore below (see the History tab to find out what the command was that RStudio generated for you).

To follow along with this example, you can download the genetic code table and save it in your current working directory:  [codons.txt](data/codons.txt).  This table has two columns:  "codon" and "aminoAcid."  To load the table into a variable:


```
## [1] "/home/gregg/r-club/content"
```



```r
codons <- read.table("codons.txt", header = TRUE, stringsAsFactors = FALSE)
head(codons)
```

```
##   codon aminoAcid
## 1   GCU         A
## 2   GCC         A
## 3   GCA         A
## 4   GCG         A
## 5   CGU         R
## 6   CGC         R
```


The `read.table` function takes a large number of optional arguments which allows it to adapt to a wide variety of different file formats.  Here we've specified `header = TRUE` because the first line of our file contains column headings.  The `stringsAsFactors = FALSE` argument tells R not to try to convert text columns to a special type of data structure called a `factor`.  Factors are intended to flag strings as describing levels of a categorical variable.  They are a more advanced topic then we'll dive into here; so we'll turn them off.


### Accessing data in a data.frame

Once your data is loaded into a data.frame (table), you can access vectors of data for individual variables in the table using the `$` syntax:


```r
codons$codon
```

```
##  [1] "GCU" "GCC" "GCA" "GCG" "CGU" "CGC" "CGA" "CGG" "AGA" "AGG" "AAU"
## [12] "AAC" "GAU" "GAC" "UGU" "UGC" "CAA" "CAG" "GAA" "GAG" "GGU" "GGC"
## [23] "GGA" "GGG" "CAU" "CAC" "AUU" "AUC" "AUA" "AUG" "UUA" "UUG" "CUU"
## [34] "CUC" "CUA" "CUG" "AAA" "AAG" "UUU" "UUC" "CCU" "CCC" "CCA" "CCG"
## [45] "UCU" "UCC" "UCA" "UCG" "AGU" "AGC" "ACU" "ACC" "ACA" "ACG" "UGG"
## [56] "UAU" "UAC" "GUU" "GUC" "GUA" "GUG" "UAA" "UGA" "UAG"
```

```r
codons$aminoAcid
```

```
##  [1] "A"    "A"    "A"    "A"    "R"    "R"    "R"    "R"    "R"    "R"   
## [11] "N"    "N"    "D"    "D"    "C"    "C"    "Q"    "Q"    "E"    "E"   
## [21] "G"    "G"    "G"    "G"    "H"    "H"    "I"    "I"    "I"    "M"   
## [31] "L"    "L"    "L"    "L"    "L"    "L"    "K"    "K"    "F"    "F"   
## [41] "P"    "P"    "P"    "P"    "S"    "S"    "S"    "S"    "S"    "S"   
## [51] "T"    "T"    "T"    "T"    "W"    "Y"    "Y"    "V"    "V"    "V"   
## [61] "V"    "STOP" "STOP" "STOP"
```


If we want to access a single data point we can use indexing syntax with `[]`.  When we are working with a 2D data structure, we can specific a `[row, col]`:


```r
codons[1, 2]
```

```
## [1] "A"
```

```r
codons[2, 1]
```

```
## [1] "GCC"
```


Let's explore indexing syntax in greater depth...


### Indexing syntax in R:  extracting & replacing values

Let's say we have a vector of numbers:

```r
myNumbers <- c(10, 20, 30, 40, 50)
```


We can extract elements from 1D vectors using the index syntax `[]` and integers:

```r
myNumbers
```

```
## [1] 10 20 30 40 50
```

```r
myNumbers[1]
```

```
## [1] 10
```

```r
myNumbers[3]
```

```
## [1] 30
```


Here, we've extracted elements at the position given by the integer we put inside of the `[...]`.  Remember that the `1` and `3` are actually vectors of integers.  Of course this means we can also use integer vectors with more than one element inside of our index `[...]`'s.  For example:


```r
myNumbers[c(1, 3)]
```

```
## [1] 10 30
```


You can use the `:` operator to easily create a sequence of numbers:

```r
# The : operator creates a series of numbers
1:5
```

```
## [1] 1 2 3 4 5
```

```r
2:10
```

```
## [1]  2  3  4  5  6  7  8  9 10
```

```r
# We can use this inside of our [...]
myNumbers[2:3]
```

```
## [1] 20 30
```


In addition to putting integer vectors inside of the index `[...]` we can also use logical vectors.  If we do, `TRUE` at a position causes a value to be extracted, while a `FALSE` indicates that it should be skipped.  Let's look at an example:


```r
myNumbers
```

```
## [1] 10 20 30 40 50
```

```r
myNumbers[c(FALSE, TRUE, TRUE, TRUE, TRUE)]
```

```
## [1] 20 30 40 50
```

```r
myNumbers[c(TRUE, FALSE, FALSE, FALSE, FALSE)]
```

```
## [1] 10
```


So why would you ever want to do this?  The answer lies in the combination of indexing and the logical operators (`>`, `<`, `==`, `!=`, and `%in%`).

With logical operators, you can ask if one vector of values or greater `>` or less `<` than another vector of values.  You can also ask if one vector of values is equal `==` or not equal `!=` to another.  Here are some examples:


```r
myNumbers > 25
```

```
## [1] FALSE FALSE  TRUE  TRUE  TRUE
```

```r
myNumbers < 25
```

```
## [1]  TRUE  TRUE FALSE FALSE FALSE
```

```r
# Equality comparison uses == instead of =
myNumbers == 30
```

```
## [1] FALSE FALSE  TRUE FALSE FALSE
```

```r
# The `!` operator negates logical vectors ('not')
myNumbers != 30
```

```
## [1]  TRUE  TRUE FALSE  TRUE  TRUE
```

```r
!(myNumbers > 25)
```

```
## [1]  TRUE  TRUE FALSE FALSE FALSE
```


**NOTE `=` vs `==`:** Many beginers are confused by the difference between `=` and `==`.   The `=` operator is used for value assignment, traditionally for arguments inside of function calls such as `plot(x = 10, y = 1)`, or in newer versions of R in place of the `<-` operator as in `a = 10`.  If you want to compare *equivalence* between two values you'll want to use the double `==` operator.  These operations will evaluate to a logical vector (`TRUE` or `FALSE`).

So how can we combine logical comparisons with indexing?  Here's an example, which is a very common idiom in R:


```r
myNumbers[myNumbers > 25]
```

```
## [1] 30 40 50
```

```r
myNumbers[myNumbers < 25]
```

```
## [1] 10 20
```


You can get fancy...


```r
myNumbers[(myNumbers%%2) == 0]
```

```
## [1] 10 20 30 40 50
```


What happened there?  If you need help figuring it out, look up the `%%` (*modulo*) operator on the help panel.

Finally, the indexing `[...]` syntax isn't just used to extract values from data structures.  It can also be used to assign values *into* existing structures.  For example:


```r
myNumbers
```

```
## [1] 10 20 30 40 50
```

```r
myNumbers[3] <- 100
myNumbers
```

```
## [1]  10  20 100  40  50
```

```r
myNumbers[2:3] <- c(1, 2)
myNumbers
```

```
## [1] 10  1  2 40 50
```


Now, back to our table...


### Calculating a new column

We can use the `$` syntax (like the `[...]`) to assign data to existing columns on a `data.frame` or to create a new column.  Let's say that we want to add a new column to our `codons` table that will annotate what type of amino acid is encoded by each codon (non-polar, polar, acidic or basic).

We can start by creating a new column called `type` that contains all `NA` values:


```r
codons$type <- NA
head(codons)
```

```
##   codon aminoAcid type
## 1   GCU         A   NA
## 2   GCC         A   NA
## 3   GCA         A   NA
## 4   GCG         A   NA
## 5   CGU         R   NA
## 6   CGC         R   NA
```


Here could have hand-encoded a vector of 20 strings describing the type of each amino acid in our table.  But we'll take the lazier path and learn a few new R tricks along the way.  Let's make some vectors that describe which amino acids belong to each of the four categories:


```r
# Assuming physiological pH; we'll call histidine basic for simplicity!
nonpolar <- c("A", "C", "G", "I", "L", "M", "F", "P", "W", "V")
polar <- c("N", "Q", "S", "T", "Y")
acidic <- c("D", "E")
basic <- c("R", "H", "K")
# We can make sure we've annotated all 20 amino acids
length(c(nonpolar, polar, acidic, basic)) == 20
```

```
## [1] TRUE
```


Now we can update our `type` column using the annotations that we've saved in these variables.  The logical `%in%` operator tests whether or not one vector of values (left side) is found in another (right side).  It returns a vector of boolean values of the same length as the left-hand test vector.  So we can do this:


```r
# Which rows contain nonpolar amino acids?
codons$aminoAcid %in% nonpolar
```

```
##  [1]  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [12] FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE  TRUE  TRUE
## [23]  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [34]  TRUE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [45] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
## [56] FALSE FALSE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE
```

```r
# We can use these logical vectors to assign our type annotations
codons[codons$aminoAcid %in% nonpolar, "type"] <- "nonpolar"
codons[codons$aminoAcid %in% polar, "type"] <- "polar"
codons[codons$aminoAcid %in% acidic, "type"] <- "acidic"
codons[codons$aminoAcid %in% basic, "type"] <- "basic"
# Check to see if it worked...
head(codons)
```

```
##   codon aminoAcid     type
## 1   GCU         A nonpolar
## 2   GCC         A nonpolar
## 3   GCA         A nonpolar
## 4   GCG         A nonpolar
## 5   CGU         R    basic
## 6   CGC         R    basic
```


Pretty neat, eh?  Working with numeric data in table columns is even more straight forward.  In R, it's very easy to create new columns that are calculated from exisiting data, as you might be used to doing in Excel.  In R, however, adding complex annotation columns like `type` above is also very simple.

Notice how we accomplished this task by composing a few minimal data structures, followed by a few relatively straight-forward assignments.  We never had to repeat assignment of any of our amino acid types.  In both software design and data analysis we always try to adhere to the "[DRY](http://en.wikipedia.org/wiki/Don't_repeat_yourself)" (don't repeat yourself) principle.  

This is much easier to do when working with tabular data in R than it is in traditional spreadsheet packages or other statistical environments.
