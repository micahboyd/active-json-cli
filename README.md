# ActiveJson

Format, query, and pluck data from JSON response files from the command line.

## Installation

    $ gem install active_json

## Usage

###### example.json


```json
[
  {
    "drink_name": "latte",
    "prices": { "small": 3.5, "medium": 4.0, "large": 4.5 },
  }
]
```

##### Command breakdown
  $ `gem command` + `json_path` + `query command(s)`

#### Filtering:

Filter JSON content with the `where` keyword followed by an attribute comparison filter (`==` `!=` `<=` `>=` `<` `>`).

For example running the following command...

    $ bin/active_json example.json where: 'drink_name == "latte"'

...will return all entries whose `drink_name` keyword is "latte"

If the JSON contains nested content you are able to query it as well:

    $ bin/active_json example.json where: 'prices.small >= 3.5'

You are able chain any number of filters:

    $ bin/active_json example.json where: 'drink_name == "latte", prices.small <= 3.5'

You can also compare attributes with one another:

    $ bin/active_json example.json where: 'prices.small >= prices.large'

Running the command without a `where` filter will return all JSON entries.

#### Plucking:

If you would rather return a particular attribute rather than the whole entry you can use the `pluck` keyword to only return a specified attribute. Running...

    $ bin/active_json example.json where: 'drink_name == "latte"' pluck: prices.small

...will return the `prices.small` attribute of all the entries whose `drink_name` keyword is "latte"

Likewise running the `pluck` command without a `where` filter will return the specified attributes of all JSON entries.
