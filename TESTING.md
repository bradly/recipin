# Testing the Recipe Parsing Logic

This project relies on **VCR** to record and replay real HTTP responses in the
test suite.  Using VCR keeps the tests **fast**, **repeatable**, and **offline
friendly** while still exercising the full `RecipeExtractor` stack.

## Directory layout

- `test/fixtures/vcr_cassettes/` – YAML cassettes (recorded HTTP
  interactions).  The entire directory is excluded from Git via `.gitignore` –
  only a `.gitkeep` placeholder is tracked so the folder exists on fresh
  clones.

  **Why are cassettes ignored?**  Personal recipe URLs may expose private
  browsing history or inadvertently redistribute copyrighted HTML.  Keeping
  them local avoids licensing headaches while still giving every developer a
  convenient harness.

## Recording a new cassette

1. **Pick a recipe URL** that you want to add as a regression test.
2. Run the following rake task:

   ```bash
   # Uses the URL itself (parameter-ized) for the cassette name
   bin/rails parsing:record_vcr[https://www.allrecipes.com/recipe/24074/alysias-basic-meat-lasagna]

   # …or provide a custom cassette name
   bin/rails parsing:record_vcr[https://www.bbcgoodfood.com/recipes/lemon-drizzle,citrus_cake]
   ```

The task will:

- Boot Rails
- Configure VCR in **record-all** mode
- Fetch the URL through `RecipeExtractor`
- Write the cassette to `test/fixtures/vcr_cassettes/<name>.yml`

## Adding an assertion

Open (or create) a test file under `test/parsing/` and wrap your extraction
code in `VCR.use_cassette`:

```ruby
VCR.use_cassette('citrus_cake') do
  extractor = RecipeExtractor.new('https://www.bbcgoodfood.com/recipes/lemon-drizzle')
  data = extractor.data

  assert_equal 'Lemon drizzle cake', data[:name]
end
```

When the cassette is missing the test will be **skipped** (helpful for CI
environments without network access).  Run the rake task locally to create it
and the test will automatically start running.

## Test run cheatsheet

```bash
# Run the full suite
bin/rails test

# Run only the parsing tests
bin/rails test test/parsing

# Re-record a single cassette
bin/rails parsing:record_vcr[<url>,<cassette_name>]
```

Happy parsing! 🥣
