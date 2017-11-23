
## Google spreadsheets

To fetch the data from the spreadsheet, make sure you have your passwords up to
date, and run the following command:

```
bin/spreadsheets2ledger > golds.txt
```

Then use ledger to query the golds:

```
ledger -f golds.txt balance Expenses Assets:Equipment --depth 1 --period="2017-08" --date-format "%Y-%m-%d"
ledger -f golds.txt balance Assets
ledger -f golds.txt balance ".*HugoPeixoto.*"
```


## Ruby lib

This repo contains parsers and generators for multiple formats: Ledger, TSV, JSON.

* Ledger will be our canonical format.
* TSV is only relevant while we're importing from google spreadsheets.
* JSON is useful for web API integrations.

Here are two snippets, converting from ledger to json and vice versa:

```
require 'lib/golds/ledger'
require 'lib/golds/json'

transactions = Golds::Ledger.load(File.read("golds.txt"))

Golds::JSON.dump(transactions)
```

```
require 'lib/golds/ledger'
require 'lib/golds/json'

transactions = Golds::JSON.load(File.read("golds.json"))

Golds::Ledger.dump(transactions)
```
