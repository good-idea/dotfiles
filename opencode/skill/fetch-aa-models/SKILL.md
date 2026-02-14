---
name: fetch-aa-models
description: Fetches LLM model benchmarks and metrics from Artificial Analysis API for model selection decisions
---

# Fetch Artificial Analysis Models

Retrieves current LLM benchmark data from Artificial Analysis, including intelligence scores, coding capability indices, and speed metrics.

## When to Use

- When comparing model capabilities for agent configuration
- When @otto-model-advisor needs quality/speed metrics beyond pricing
- When evaluating model tradeoffs (capability vs cost vs speed)

## Usage

Run the co-located fetch script:

```bash
~/.opencode/skill/fetch-aa-models/scripts/fetch.sh
```

## API Key Setup

The script looks for `ARTIFICIAL_ANALYSIS_API_KEY` in this order:

1. Environment variable (if already exported)
2. `.env` file in current directory
3. `.env` file in any parent directory (walks up the tree)
4. `~/.env` in home directory

### Getting an API Key

1. Create a free account at https://artificialanalysis.ai/login
2. Generate an API key in the Insights Platform
3. Add to your `.env` file:

```
ARTIFICIAL_ANALYSIS_API_KEY=your_key_here
```

The free tier allows 1,000 requests per day.

## Response Format

The API returns JSON with model data:

```json
{
  "status": 200,
  "data": [
    {
      "id": "uuid",
      "name": "Claude Sonnet 4.5",
      "slug": "claude-sonnet-4-5",
      "model_creator": {
        "name": "Anthropic"
      },
      "evaluations": {
        "artificial_analysis_intelligence_index": 64.1,
        "artificial_analysis_coding_index": 62.3,
        "artificial_analysis_math_index": 58.7
      },
      "median_output_tokens_per_second": 82.4,
      "median_time_to_first_token_seconds": 0.89
    }
  ]
}
```

### Key Fields

| Field                                                | Description                           |
| ---------------------------------------------------- | ------------------------------------- |
| `evaluations.artificial_analysis_intelligence_index` | Overall reasoning capability (0-100)  |
| `evaluations.artificial_analysis_coding_index`       | Code generation/understanding (0-100) |
| `median_output_tokens_per_second`                    | Response generation speed             |
| `median_time_to_first_token_seconds`                 | Latency before first token            |

## Error Handling

If the API key is not found, the script returns:

```json
{
  "error": "ARTIFICIAL_ANALYSIS_API_KEY not found",
  "searched": ["...locations checked..."],
  "setup": "Add ARTIFICIAL_ANALYSIS_API_KEY=your_key to a .env file"
}
```

## Attribution

When using this data, include attribution to https://artificialanalysis.ai/ as required by their API terms.
