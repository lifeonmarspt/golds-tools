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

Have fun :)
