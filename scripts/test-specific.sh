#!/bin/bash

if [ -z "$1" ]; then
    echo "❌ Error: Please provide test class name"
    echo "Usage: ./scripts/test-specific.sh <TestClassName>"
    exit 1
fi

echo "🧪 Running Test Class: $1"
echo "========================"

sf apex run test \
    --tests $1 \
    --result-format human \
    --code-coverage \
    --wait 10 \
    --detailed-coverage