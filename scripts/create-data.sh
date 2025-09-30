echo "📊 Creating Sample Data"
echo "======================"

# Create sample account
echo "Creating sample account..."
sf data create record \
    --sobject Account \
    --values "Name='Health Test Account' Weight__c=70 Height__c=1.75 Age__c=30" \
    --target-org HrsmMetricsScratch

# Create sample lead
echo "Creating sample lead..."
sf data create record \
    --sobject Lead \
    --values "FirstName='John' LastName='Doe' Company='Test Company' Email='john@test.com' Phone='1234567890' Weight__c=80 Height__c=1.80 ExternalId__c='TEST001'" \
    --target-org HrsmMetricsScratch

echo "✅ Sample data created successfully!"