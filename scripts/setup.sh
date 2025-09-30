#!/bin/bash
# ============================================
# FILE: scripts/setup.sh
# Description: Complete setup script for scratch org
# ============================================

echo "🚀 Health Metrics App - Scratch Org Setup"
echo "=========================================="

# Step 1: Create scratch org
echo ""
echo "📦 Step 1: Creating scratch org..."
sf org create scratch \
    --definition-file config/project-scratch-def.json \
    --alias HrsmMetricsScratch \
    --duration-days 30 \
    --set-default \
    --no-namespace

if [ $? -eq 0 ]; then
    echo "✅ Scratch org created successfully"
else
    echo "❌ Failed to create scratch org"
    exit 1
fi

# Step 2: Deploy metadata
echo ""
echo "📤 Step 2: Deploying metadata to scratch org..."
sf project deploy start --source-dir force-app

if [ $? -eq 0 ]; then
    echo "✅ Metadata deployed successfully"
else
    echo "❌ Failed to deploy metadata"
    exit 1
fi

# Step 3: Run tests
echo ""
echo "🧪 Step 3: Running Apex tests..."
sf apex run test \
    --test-level RunLocalTests \
    --result-format human \
    --code-coverage \
    --wait 10

if [ $? -eq 0 ]; then
    echo "✅ All tests passed"
else
    echo "⚠️  Some tests may have failed. Check the results above."
fi

# Step 4: Generate password
echo ""
echo "🔑 Step 4: Generating password for scratch org..."
sf org generate password --target-org HrsmMetricsScratch

# Step 5: Display org info
echo ""
echo "📋 Step 5: Org Information"
sf org display --target-org HrsmMetricsScratch

# Step 6: Open scratch org
echo ""
echo "🌐 Opening scratch org in browser..."
sf org open --target-org HrsmMetricsScratch

echo ""
echo "=========================================="
echo "✨ Setup complete! Happy coding!"
echo "=========================================="