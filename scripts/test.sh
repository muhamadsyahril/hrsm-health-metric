#!/bin/bash

echo "🧪 Running All Tests"
echo "==================="

sf apex run test \
    --test-level RunLocalTests \
    --result-format human \
    --code-coverage \
    --wait 10 \
    --detailed-coverage

echo ""
echo "Test execution complete!"