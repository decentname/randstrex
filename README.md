# Randstrex

**Random String Generator using Regex**

## How to Install
```
cd randstrex && mix deps.get
```

## How to Run

```
iex -S mix
```

## Example

```elixir
Randstrex.generate("/[-+]?[0-9]{1,16}[.][0-9]{1,6}/", 10)
{:ok,
 ["8136297045.6015", "9472503861.9675", "01358.83247", "+573.25",
  "+768405219.290", "2048659137.810429", "+8591602347.2", "9702584163.132950",
  "-132580497.25", "+620.1479"]}
 ```

