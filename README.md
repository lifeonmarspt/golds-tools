To fetch the data from the spreadsheet, make sure you have your passwords up to
date, and run the following commands:

```
bin/spreadsheets-jwt |
bin/spreadsheets-access-token |
bin/spreadsheets |
bin/spreadsheets-json2tsv |
bin/tsv2ledger > golds.txt
```

Then use ledger to query the golds:

```
ledger -f golds.txt balance Expenses --depth 2
```

Have fun :)
