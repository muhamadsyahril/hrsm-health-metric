#!/bin/bash

echo "🗑️  Cleaning up scratch org"
echo "=========================="

read -p "Are you sure you want to delete the scratch org? (y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    sf org delete scratch \
        --target-org HrsmMetricsScratch \
        --no-prompt
    
    echo "✅ Scratch org deleted successfully!"
else
    echo "❌ Cleanup cancelled"
fi