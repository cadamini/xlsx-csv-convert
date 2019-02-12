
# xlsx File parser Version 0.4 (beta)

> This project is work in progress. I use this to learn TDD and object-oriented ruby

## Usage Instructions

- 1. install ruby
- 2. copy this package into a folder
- 3. start ruby run.rb

## Example
The file run.rb contains an example how to run the converter

```
options = {
  columns: {
    date: 5,
    queue_name: 3,
    handling_time: [6, 7] # mutiple elements or integer
  },
  # more options (optional)
  import_path: 'import', # default 'import'
  export_path: 'export'  # default 'export'
}
Excel2CsvConvert.run(options)
```

## Hints

1. Any other conversion would use a different import folder due to different format
2. Column numbers are currently starting at 0, so the second column would be 1.

## Contribution 

Feel free to contribute via pull requests or let me know what I can inmprove in issues.
