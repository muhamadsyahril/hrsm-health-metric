#!/bin/bash

echo "🚀 Deploying Hrsm Health Metrics App"
echo "==============================="

# Validate before deploy
echo ""
echo "🔍 Validating deployment..."
sf project deploy start \
    --source-dir force-app \
    --test-level RunLocalTests \
    --dry-run

if [ $? -eq 0 ]; then
    echo "✅ Validation successful"
    
    # Prompt for confirmation
    read -p "Do you want to proceed with deployment? (y/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "📤 Deploying to org..."
        sf project deploy start \
            --source-dir force-app \
            --test-level RunLocalTests \
            --wait 10
        
        if [ $? -eq 0 ]; then
            echo "✅ Deployment successful!"
        else
            echo "❌ Deployment failed"
            exit 1
        fi
    else
        echo "❌ Deployment cancelled"
        exit 0
    fi
else
    echo "❌ Validation failed"
    exit 1
fi